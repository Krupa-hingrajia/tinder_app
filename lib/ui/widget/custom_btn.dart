import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/constant/text_style_constant.dart';

customButton(
    {GestureTapCallback? onTap,
    double? height,
    double? width,
    required String text,
    bool circular = false,
    Color? color}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [color ?? ColorConstant.greenLight, color ?? ColorConstant.yellowLight])),
      child: circular
          ? const CircularProgressIndicator(color: ColorConstant.blue)
          : Center(child: Text(text ?? '', style: TextStyleConstant.logInBtnStyle)),
    ),
  );
}
