import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/constant/image_constant.dart';
import 'package:tinder_app_new/core/routing/routes.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/splash_screen_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AfterLayoutMixin<SplashScreen> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);

    if (seen) {
      Timer(const Duration(seconds: 5), () {
        Navigator.pushNamedAndRemoveUntil(context, Routes.allScreenBottom, (route) => false);
      });
    } else {
      // await prefs.setBool('seen', true);
      Timer(const Duration(seconds: 5), () {
        Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);
      });
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  SplashScreenViewModel? model;

  @override
  Widget build(BuildContext context) {
    return BaseView<SplashScreenViewModel>(
      builder: (buildContext, model, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [ColorConstant.yellowLight, ColorConstant.greenLight],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: [0.2, 0.7],
                tileMode: TileMode.repeated,
              ),
            ),
            child: Center(
                child: Image.asset(
              ImageConstant.splashLogo,
              color: ColorConstant.black,
            )),
          ),
        );
      },
      onModelReady: (model) {
        this.model = model;
      },
    );
  }
}
