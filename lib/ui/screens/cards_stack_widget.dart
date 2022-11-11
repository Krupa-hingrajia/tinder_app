import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/enum/viewstate.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/cards_stack_widget_view_model.dart';

import '../../core/model/cards_model.dart';
import '../widget/notification_badge.dart';
import 'drag_widget.dart';

class CardsStackWidget extends StatefulWidget {
  const CardsStackWidget({Key? key}) : super(key: key);

  @override
  State<CardsStackWidget> createState() => _CardsStackWidgetState();
}

class _CardsStackWidgetState extends State<CardsStackWidget> with SingleTickerProviderStateMixin {
  CardsStackWidgetViewModel? model;
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  late final FirebaseMessaging _messaging;
  List<ProfilePicture> list = [];
  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);
  late final AnimationController _animationController;

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        list.removeLast();
        _animationController.reset();
        swipeNotifier.value = Swipe.none;
      }
    });
    registerNotification();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    list.clear();
    print('DISPOSE');
  }

  getImages() async {
    var data = await firebase.collection('Users').where('gender', isEqualTo: model!.genderGet).get();
    for (int i = 0; i < data.docs.length; i++) {
      ProfilePicture model = ProfilePicture(data.docs[i].data()['image_url'], data.docs[i].data()['name'],
          data.docs[i].data()['gender'], data.docs[i].data()['id'], data.docs[i].data()['isFavourite']);
      list.add(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<CardsStackWidgetViewModel>(
      builder: (buildContext, model, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FutureBuilder(
                future: getImages(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ValueListenableBuilder(
                      valueListenable: swipeNotifier,
                      builder: (context, swipe, _) => Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: List.generate(list.length, (index) {
                            if (index == list.length - 1) {
                              return PositionedTransition(
                                rect: RelativeRectTween(
                                  begin:
                                      RelativeRect.fromSize(const Rect.fromLTWH(0, 0, 580, 340), const Size(580, 340)),
                                  end: RelativeRect.fromSize(
                                      Rect.fromLTWH(
                                          swipe != Swipe.none
                                              ? swipe == Swipe.left
                                                  ? -300
                                                  : 300
                                              : 0,
                                          0,
                                          580,
                                          340),
                                      const Size(580, 340)),
                                ).animate(CurvedAnimation(
                                  parent: _animationController,
                                  curve: Curves.easeInOut,
                                )),
                                child: RotationTransition(
                                  turns: Tween<double>(
                                          begin: 0,
                                          end: swipe != Swipe.none
                                              ? swipe == Swipe.left
                                                  ? -0.1 * 0.3
                                                  : 0.1 * 0.3
                                              : 0.0)
                                      .animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: const Interval(0, 0.4, curve: Curves.easeInOut),
                                    ),
                                  ),
                                  child: DragWidget(
                                    profile: list[index],
                                    index: index,
                                    swipeNotifier: swipeNotifier,
                                    isLastCard: true,
                                    onPressedLike: () {
                                      sendPushMessage();
                                      swipeNotifier.value = Swipe.right;
                                      _animationController.forward();
                                      addLike(list[index].id);
                                    },
                                    onPressedCancel: () {
                                      swipeNotifier.value = Swipe.left;
                                      _animationController.forward();
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return DragWidget(
                                profile: list[index],
                                index: index,
                                swipeNotifier: swipeNotifier,
                                onPressedLike: () {
                                  sendPushMessage();
                                  swipeNotifier.value = Swipe.right;
                                  _animationController.forward();
                                  addLike(list[index].id);
                                },
                                onPressedCancel: () {
                                  swipeNotifier.value = Swipe.left;
                                  _animationController.forward();
                                },
                              );
                            }
                          })),
                    );
                  }
                  return const Center(child: CircularProgressIndicator(color: ColorConstant.greenLight));
                },
              ),
            ),
            Positioned(
              left: 0,
              child: DragTarget<int>(
                builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                ) {
                  return IgnorePointer(child: Container(height: 700.0, width: 80.0, color: Colors.transparent));
                },
                onAccept: (int index) {
                  list.removeAt(index);
                },
              ),
            ),
            Positioned(
              right: 0,
              child: DragTarget<int>(
                builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                ) {
                  return IgnorePointer(child: Container(height: 700.0, width: 80.0, color: Colors.transparent));
                },
                onAccept: (int index) {
                  list.removeAt(index);
                },
              ),
            ),
          ],
        );
      },
      onModelReady: (model) {
        this.model = model;
        model.getDate();
        // model.getUserGender();
        model.updateUI();
      },
    );
  }

  addLike(String userId) async {
    await firebase.collection('Users').doc(userId).update({'isFavourite': true});
  }

  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    // sendPushMessage();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings =
        await _messaging.requestPermission(alert: true, badge: true, provisional: false, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
            'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

        showSimpleNotification(
          Text(message.notification!.title.toString(), style: const TextStyle(color: Colors.black)),
          leading: const NotificationBadge(),
          subtitle: Text(message.notification!.body.toString(), style: const TextStyle(color: Colors.black)),
          background: ColorConstant.yellowLight,
          duration: const Duration(seconds: 10),
        );
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  //Send Notifications
  Future<void> sendPushMessage() async {
    /*  print('*********___________::: {$mtoken}');
    if (mtoken == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }*/

    try {
      var headers = {
        'Authorization':
            'key=AAAA0FDqNaQ:APA91bEaEPf-lW6D4W3pXPyaI1QJKWHhYUrCHK0riCvOPvVN_LTmrrEjcLNUtHbWVuRfdBeRksSh8mY8Bxzr3IEBKLx6TovbQQzEnJG6tNKf6JjmAl10sLuW64u1C2dgPNiXa3i6Re9I',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
      request.body = json.encode({
        "to":
            "f_JCPQ6ERkubBn8tbN7qIL:APA91bEvcUfmu7FoHfj6BjBfmd2d3P39pEfjq3q7jU8n0cC3tdLLT89JvGio4fhMZc-_Lv5lHZiKfELSAvM-9bDUFHK3c3jbuBZx5tIo_Ydz5FWrhoB3umYMRKD2oPxc0lUYXKAQVjBf",
        "data": {"via": "FlutterFire Cloud Messaging!!!", "count": 1},
        "notification": {"title": "Hello Bhagheshwarji", "body": "1"}
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      print(response.toString());

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
      /*     await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Length': '<calculated when request is sent>',
          'Host': '<calculated when request is sent>',
          'Content-Type': 'application/json',
          "Authorization":
              "key=AAAA0FDqNaQ:APA91bEaEPf-lW6D4W3pXPyaI1QJKWHhYUrCHK0riCvOPvVN_LTmrrEjcLNUtHbWVuRfdBeRksSh8mY8Bxzr3IEBKLx6TovbQQzEnJG6tNKf6JjmAl10sLuW64u1C2dgPNiXa3i6Re9I"
        },
        body: {
          "to":
              "f_JCPQ6ERkubBn8tbN7qIL:APA91bEvcUfmu7FoHfj6BjBfmd2d3P39pEfjq3q7jU8n0cC3tdLLT89JvGio4fhMZc-_Lv5lHZiKfELSAvM-9bDUFHK3c3jbuBZx5tIo_Ydz5FWrhoB3umYMRKD2oPxc0lUYXKAQVjBf",
          "notification": {"title": "You Got Friend Request From Dhruval", "body": "Hii"}
        },
      );
      print('FCM request for device sent!');*/
    } catch (e) {
      print(e);
    }
  }
}
