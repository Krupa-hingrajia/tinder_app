import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/provider/theme_changer.dart';
import 'core/routing/locator/locator.dart';
import 'core/routing/router.dart';
import 'core/routing/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setLocator();

  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool("darkMode") ?? true;

    runApp(
      ChangeNotifierProvider<ThemeNotifier>(
        create: (context) {
          return ThemeNotifier(darkModeOn ? darkTheme : lightTheme);
        },
        builder: (context, child) {
          return const Myapp();
        },
      ),
    );
  });
}

class Myapp extends StatefulWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return OverlaySupport(
      child: MaterialApp(
        theme: themeNotifier.getTheme(),
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.loginScreen,
        // initialRoute: Routes.signupScreen,
        // initialRoute: Routes.allScreenBottom,
        // initialRoute: Routes.settingScreen,
        onGenerateRoute: PageRouter.generateRoutes,
      ),
    );
  }
}

/*
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/ui/screens/chat_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Notify',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final FirebaseMessaging _messaging;
  late int _totalNotifications;
  PushNotification? _notificationInfo;

  String? mtoken =
      "f_JCPQ6ERkubBn8tbN7qIL:APA91bEvcUfmu7FoHfj6BjBfmd2d3P39pEfjq3q7jU8n0cC3tdLLT89JvGio4fhMZc-_Lv5lHZiKfELSAvM-9bDUFHK3c3jbuBZx5tIo_Ydz5FWrhoB3umYMRKD2oPxc0lUYXKAQVjBf";

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print('*********** TOKEN  ********* ${mtoken}');
      });
    });
  }

  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    // sendPushMessage();
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

        showSimpleNotification(
          Text(message.notification!.title.toString(), style: TextStyle(color: Colors.black)),
          leading: const NotificationBadge(),
          subtitle: Text(message.notification!.body.toString(), style: TextStyle(color: Colors.black)),
          background: ColorConstant.yellowLight,
          duration: Duration(seconds: 10),
        );

        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });

        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          showSimpleNotification(
            Text('my title'),
            //   leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text('Show'),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 20),
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    }
  }

  @override
  void initState() {
    // _totalNotifications = 0;
    // getToken();
    registerNotification();
    // sendPushMessage();
    // checkForInitialMessage();

    // For handling notification when the app is in background
    // but not terminated

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    });

    super.initState();
  }

  Future<void> sendPushMessage() async {
    print('*********___________::: {$mtoken}');
    if (mtoken == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

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
        "notification": {"title": "Hello FlutterFire", "body": "1"}
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      print(response.toString());

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
      await http.post(
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
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notify'),
        brightness: Brightness.dark,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                print("***********************  SEND NOTIFICATIONS  ****************************");
                sendPushMessage();
              },
              child: Text('Send Notification')),
          GestureDetector(
            onTap: () {
              // registerNotification();
            },
            child: Text(
              'App for capturing Firebase Push Notifications',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          //  NotificationBadge(totalNotifications: _totalNotifications),
          SizedBox(height: 16.0),
          _notificationInfo != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TITLE: ${_notificationInfo!.dataTitle ?? _notificationInfo!.title}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'BODY: ${_notificationInfo!.dataBody ?? _notificationInfo!.body}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: const BoxDecoration(
        color: ColorConstant.greenLight,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'T',
            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
*/
