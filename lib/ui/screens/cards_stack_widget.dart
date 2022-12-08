import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/enum/viewstate.dart';
import 'package:tinder_app_new/core/utils/register_notification.dart';
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
  String? profileImage;
  String? id;
  String? genderGet;
  String? ageRangeGet;
  bool? showTinderGet;
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  late final FirebaseMessaging _messaging;
  List<ProfilePicture> profilePicture = [];
  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);
  late final AnimationController _animationController;

  bool? likeIndex = false;

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefValue) => {
          setState(() {
            genderGet = prefValue.getString('gender');
            ageRangeGet = prefValue.getString('ageRange');
            showTinderGet = prefValue.getBool('switchState');
            id = prefValue.getString('id');
          })
        });
    _animationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        profilePicture.removeLast();
        _animationController.reset();
        swipeNotifier.value = Swipe.none;
      }
    });
  }

  getImages() async {
    var data = await firebase.collection('Users').where('gender', isEqualTo: genderGet).get();
    profilePicture.clear();
    for (int i = 0; i < data.docs.length; i++) {
      ProfilePicture model = ProfilePicture(data.docs[i].data()['image_url'], data.docs[i].data()['name'],
          data.docs[i].data()['gender'], data.docs[i].data()['id'], data.docs[i].data()['like_list']);
      profilePicture.add(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<CardsStackWidgetViewModel>(
      builder: (buildContext, model, child) {
        return Stack(clipBehavior: Clip.none, children: [
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
                        children: List.generate(profilePicture.length, (index) {
                          if (index == profilePicture.length - 1) {
                            return PositionedTransition(
                              rect: RelativeRectTween(
                                begin: RelativeRect.fromSize(const Rect.fromLTWH(0, 0, 580, 340), const Size(580, 340)),
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
                                  profile: profilePicture[index],
                                  index: index,
                                  swipeNotifier: swipeNotifier,
                                  isLastCard: true,
                                  onPressedLike: () async {
                                    profileImage = profilePicture[index].imageURL;
                                    // sendPushMessage(profilePicture[index].id.toString());
                                    swipeNotifier.value = Swipe.right;
                                    _animationController.forward();
                                    model.addLike(id!, profilePicture[index].id.toString());
                                    print('PROFILE ID :- ${profilePicture[index].id.toString()}');
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
                              profile: profilePicture[index],
                              index: index,
                              swipeNotifier: swipeNotifier,
                              onPressedLike: () {
                                // sendPushMessage(profilePicture[index].id.toString());
                                swipeNotifier.value = Swipe.right;
                                _animationController.forward();
                                model.addLike(id!, profilePicture[index].id.toString());
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
                profilePicture.removeAt(index);
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
                  profilePicture.removeAt(index);
                },
              ))
        ]);
      },
      onModelReady: (model) {
        this.model = model;
        getImages();
      },
    );
  }

  // void registerNotification() async {
  //   await Firebase.initializeApp();
  //   _messaging = FirebaseMessaging.instance;
  //   // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //
  //   NotificationSettings settings =
  //       await _messaging.requestPermission(alert: true, badge: true, provisional: false, sound: true);
  //
  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //       showSimpleNotification(
  //         background: ColorConstant.white,
  //         elevation: 0,
  //         autoDismiss: true,
  //         slideDismiss: true,
  //         duration: const Duration(seconds: 5),
  //         GestureDetector(
  //             /*onTap: () {
  //               Navigator.pushNamed(context, Routes.notificationScreen,
  //                   arguments: MessageArguments(title: message.data['name'], image: message.data['image'], id: id));
  //             },*/
  //             child: Text(message.notification!.title.toString(), style: const TextStyle(color: Colors.black))),
  //         leading: const NotificationBadge(),
  //         subtitle: Text(message.notification!.body.toString(), style: const TextStyle(color: Colors.black)),
  //       );
  //     });
  //   } else {
  //     print('User declined or has not accepted permission');
  //   }
  // }
  //
  // Future<void> sendPushMessage(String userId) async {
  //   final querySnapshot = await firebase.collection('Users').where('id', isEqualTo: userId).get();
  //
  //   for (var element in querySnapshot.docs) {
  //     model!.userToken = element.get('useToken');
  //     model!.userName = element.get('name');
  //     model!.image = element.get('image_url');
  //     print('TOKEN ::- ${model!.userToken}');
  //   }
  //
  //   try {
  //     var headers = {
  //       'Authorization':
  //           'key=AAAA0FDqNaQ:APA91bEaEPf-lW6D4W3pXPyaI1QJKWHhYUrCHK0riCvOPvVN_LTmrrEjcLNUtHbWVuRfdBeRksSh8mY8Bxzr3IEBKLx6TovbQQzEnJG6tNKf6JjmAl10sLuW64u1C2dgPNiXa3i6Re9I',
  //       'Content-Type': 'application/json'
  //     };
  //     var request = http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
  //     request.body = json.encode({
  //       "to": model!.userToken,
  //       "data": {"name": model!.userName, "image": model!.image},
  //       "notification": {
  //         "title": "Tinder 😍😍😍",
  //         "body": "${model!.userName} send you match request!!",
  //       }
  //     });
  //     request.headers.addAll(headers);
  //
  //     http.StreamedResponse response = await request.send();
  //
  //     if (response.statusCode == 200) {
  //       print(await response.stream.bytesToString());
  //     } else {
  //       print(response.reasonPhrase);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
/*Stack(clipBehavior: Clip.none, children: [
          FutureBuilder(
            future: getImages(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Swiper(
                  loop: false,
                  itemCount: profilePicture.length,
                  itemBuilder: (context, index) {
                    model.newIndex = index;
                    return Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.15,
                          bottom: MediaQuery.of(context).size.height * 0.10,
                          right: MediaQuery.of(context).size.width * 0.05,
                          left: MediaQuery.of(context).size.width * 0.05),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: profilePicture[index].imageURL!,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                              ),
                            ),
                            placeholder: (context, url) =>
                                const Center(child: CircularProgressIndicator(color: ColorConstant.greenLight)),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).size.height * 0.040,
                                  left: MediaQuery.of(context).size.width * 0.06),
                              child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(.5),
                                          borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(20), topLeft: Radius.circular(20))),
                                      height: MediaQuery.of(context).size.height * 0.095,
                                      width: double.infinity,
                                      child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            Text(profilePicture[index].userName.toString(),
                                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                                            Text(profilePicture[index].gender.toString(),
                                                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                                          ])))))
                        ],
                      ),
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator(color: ColorConstant.greenLight));
            },
          ),
          */
