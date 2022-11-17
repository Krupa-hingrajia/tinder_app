import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/model/edit_model.dart';
import 'package:tinder_app_new/core/model/message_model.dart';
import 'package:tinder_app_new/core/routing/routes.dart';
import 'package:tinder_app_new/ui/screens/all_screen_bottom.dart';
import 'package:tinder_app_new/ui/screens/chat_screen.dart';
import 'package:tinder_app_new/ui/screens/home_screen.dart';
import 'package:tinder_app_new/ui/screens/login_screen.dart';
import 'package:tinder_app_new/ui/screens/notification_screen.dart';
import 'package:tinder_app_new/ui/screens/profile_screens/add_media_screen.dart';
import 'package:tinder_app_new/ui/screens/profile_screens/edit_profile_screen.dart';
import 'package:tinder_app_new/ui/screens/profile_screens/profile_screen.dart';
import 'package:tinder_app_new/ui/screens/profile_screens/setting_screen.dart';
import 'package:tinder_app_new/ui/screens/signup_screen.dart';
import 'package:tinder_app_new/ui/screens/splash_screen.dart';

class PageRouter {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case Routes.signupScreen:
        return MaterialPageRoute(builder: (context) => const SignUpScreen());
      case Routes.allScreenBottom:
        return MaterialPageRoute(builder: (context) => const AllScreenBottom());
      case Routes.profileScreen:
        return MaterialPageRoute(builder: (context) => const ProfileScreen());
      case Routes.settingScreen:
        return MaterialPageRoute(builder: (context) => const SettingScreen());
      case Routes.addMediaScreen:
        return MaterialPageRoute(builder: (context) => const AddMediaScreen());
      case Routes.editProfileScreen:
        EditArguments editArguments = settings.arguments as EditArguments;
        return MaterialPageRoute(builder: (context) => EditProfileScreen(editArguments: editArguments));
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case Routes.notificationScreen:
        MessageArguments messageArguments = settings.arguments as MessageArguments;
        return MaterialPageRoute(builder: (context) => NotificationScreen(messageArguments: messageArguments));
      case Routes.chatScreen:
        return MaterialPageRoute(builder: (context) => const ChatScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text("No page Found"),
            ),
          ),
        );
    }
  }
}
