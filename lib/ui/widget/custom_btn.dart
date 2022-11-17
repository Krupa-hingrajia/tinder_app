import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/constant/text_style_constant.dart';

customButton(
    {required VoidCallback onPressed, double? height, double? width, required String text, bool circular = false}) {
  return SizedBox(
    height: height,
    width: width,
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        onPressed: onPressed,
        child: circular
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: ColorConstant.greenLight))
            : Text(text ?? '', style: TextStyleConstant.logInBtnStyle)),
  );
}
