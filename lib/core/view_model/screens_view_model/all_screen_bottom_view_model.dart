import 'package:flutter/cupertino.dart';
import 'package:tinder_app_new/core/view_model/base_model.dart';
import 'package:tinder_app_new/ui/screens/chat_screen.dart';
import 'package:tinder_app_new/ui/screens/home_screen.dart';
import 'package:tinder_app_new/ui/screens/notification_screen.dart';
import 'package:tinder_app_new/ui/screens/profile_screens/profile_screen.dart';

class AllScreenBottomViewModel extends BaseModel {
  int selectedIndex = 0;
  static List<Widget> pages = <Widget>[
    const HomeScreen(),
    NotificationScreen(),
    ChatScreen(),
    const ProfileScreen()
  ];
}
