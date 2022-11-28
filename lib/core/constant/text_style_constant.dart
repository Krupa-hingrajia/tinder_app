import 'package:flutter/material.dart';

import 'color_constant.dart';

class TextStyleConstant {
  static const TextStyle sigUpStyle =
      TextStyle(color: ColorConstant.black, fontSize: 16, letterSpacing: 1, fontWeight: FontWeight.w500);
  static const TextStyle logInBtnStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
  static const TextStyle settingNameStyle =
      TextStyle(color: ColorConstant.black, fontSize: 22, fontWeight: FontWeight.bold);
  static const TextStyle settingEmailStyle = TextStyle(color: ColorConstant.black, fontSize: 19);
  static const TextStyle settingTheme = TextStyle(fontSize: 19, fontWeight: FontWeight.w500);
  static const TextStyle settingGender = TextStyle(fontSize: 19, fontWeight: FontWeight.w500);
  static const TextStyle settingAgeRange = TextStyle(fontSize: 19, fontWeight: FontWeight.w500);
  static const TextStyle settingShowTinder = TextStyle(fontSize: 19, fontWeight: FontWeight.w500);
  static TextStyle requestSenderKey =
      TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: ColorConstant.grey600);
  static TextStyle requestSenderKeyAbout =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: ColorConstant.grey600);
  static const TextStyle requestSenderValue = TextStyle(fontSize: 30, fontWeight: FontWeight.w600, letterSpacing: 1);
}
