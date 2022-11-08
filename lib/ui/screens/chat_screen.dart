import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';

import '../../core/view_model/screens_view_model/chat_screen_view_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatScreenViewModel? model;
  dynamic data;

  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;

  @override
  void initState() {
    registerNotification();
    getToken();
    super.initState();
  }

  Future _firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
    print("Handling a background message: ${message!.messageId}");
  }

  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        setState(() {
          _notificationInfo = notification;
        });

        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2),
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // For handling notification when the app is in terminated state
/*  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: 'initialMessage.data',
        dataBody: 'initialMessage.data',
      );

      print("_________________________${initialMessage.notification?.title}");
      setState(() {
        _notificationInfo = notification;
        // _totalNotifications++;
      });
    }
  }*/

  String? mtoken = " ";

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print('**************** :::  ${mtoken}');
      });
    });
  }

  String constructFCMPayload(String? token) {
    //  _messageCount++;
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': 1,
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification (1) was created via FCM!',
      },
    });
  }

  Future<void> sendPushMessage() async {
    print('*********___________::: {$mtoken}');
    if (mtoken == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization":
              "key=AAAA0FDqNaQ:APA91bEaEPf-lW6D4W3pXPyaI1QJKWHhYUrCHK0riCvOPvVN_LTmrrEjcLNUtHbWVuRfdBeRksSh8mY8Bxzr3IEBKLx6TovbQQzEnJG6tNKf6JjmAl10sLuW64u1C2dgPNiXa3i6Re9I"
        },
        body: constructFCMPayload(mtoken),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ChatScreenViewModel>(
      builder: (buildContext, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Messages'),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: <Color>[ColorConstant.yellowLight, ColorConstant.greenLight],
              )),
            ),
          ),
          body: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  registerNotification();
                  await sendPushMessage();
                },
                child: Text('Send'),
              )
              /*   */ /*FutureBuilder(
                future: readFeeds(),
                builder: (BuildContext context, snapshot) {
                  return ListView.builder(
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return const Text('data');
                      });
                }),*/ /*
              _notificationInfo!.title == null
                  ? Text('data')
                  : Text(
                      'TITLE: ${_notificationInfo!.title}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () async {
                      registerNotification();
                    },
                    child: const Text('PRESS ON')),
              )*/
            ],
          ),
        );
      },
      onModelReady: (model) {
        this.model = model;
        model.localNotification();
      },
    );
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });

  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;
}
