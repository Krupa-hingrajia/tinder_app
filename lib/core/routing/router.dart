import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/routing/routes.dart';
import 'package:tinder_app_new/ui/screens/login_screen.dart';
import 'package:tinder_app_new/ui/screens/splash_screen.dart';

class PageRouter {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
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
