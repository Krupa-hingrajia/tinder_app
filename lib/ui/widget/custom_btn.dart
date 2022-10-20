import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/constant/text_style_constant.dart';

customButton({required VoidCallback onPressed, double? height, double? width}) {
  return SizedBox(
    height: height,
    width: width,
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        onPressed: onPressed,
        child: const Text("Login", style: TextStyleConstant.logInBtnStyle)),
  );
}
