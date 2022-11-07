import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tinder_app_new/core/view_model/base_model.dart';

class ChatScreenViewModel extends BaseModel {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  localNotification() {
    AndroidInitializationSettings android = const AndroidInitializationSettings('app_icon');
    DarwinInitializationSettings ios = const DarwinInitializationSettings();

    var initSettings = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  showNotification() async {
    AndroidNotificationDetails android = const AndroidNotificationDetails(
      'id',
      'channel',
      priority: Priority.high,
      importance: Importance.max,
    );
    DarwinNotificationDetails ios = const DarwinNotificationDetails();

    var platform = NotificationDetails(android: android, iOS: ios);
    await flutterLocalNotificationsPlugin.show(0, 'Flutter devs', 'Flutter Local Notification Demo', platform);
  }
}
