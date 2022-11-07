import 'package:flutter/cupertino.dart';
import 'package:tinder_app_new/core/view_model/base_model.dart';
import 'package:tinder_app_new/ui/screens/home_screen.dart';
import 'package:tinder_app_new/ui/screens/profile_screen.dart';

import '../../../ui/screens/chat_screen.dart';

class AllScreenBottomViewModel extends BaseModel {
  int selectedIndex = 0;
  static const List<Widget> pages = <Widget>[HomeScreen(), ChatScreen(), ProfileScreen()];
}
