import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/model/profile_model.dart';
import 'package:tinder_app_new/core/routing/routes.dart';
import 'package:tinder_app_new/ui/screens/all_screen_bottom.dart';
import 'package:tinder_app_new/ui/screens/home_screen.dart';
import 'package:tinder_app_new/ui/screens/login_screen.dart';
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
        // UserArguments screenArguments = settings.arguments as UserArguments;
        return MaterialPageRoute(
            builder: (context) => const ProfileScreen(
                /*userArguments: screenArguments,*/
                ));
      case Routes.settingScreen:
        return MaterialPageRoute(builder: (context) => const SettingScreen());
        case Routes.addMediaScreen:
        return MaterialPageRoute(builder: (context) => const AddMediaScreen());
        case Routes.editProfileScreen:
        return MaterialPageRoute(builder: (context) => const EditProfileScreen());
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
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
