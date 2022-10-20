import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/routing/routes.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/splash_screen_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashScreenViewModel? model;

  @override
  Widget build(BuildContext context) {
    return BaseView<SplashScreenViewModel>(
      builder: (buildContext, model, child) {
        return Scaffold(
          body: Container(color: Colors.white, child: FlutterLogo(size: MediaQuery.of(context).size.height)),
        );
      },
      onModelReady: (model) {
        this.model = model;
        Timer(const Duration(seconds: 6), () {
          Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);
        });
      },
    );
  }
}
