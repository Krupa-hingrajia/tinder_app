import 'dart:async';

import 'package:flutter/material.dart';
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

class _SplashScreenState extends State<SplashScreen> {
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
        Timer(const Duration(seconds: 6), () {
          Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);
        });
      },
    );
  }
}
