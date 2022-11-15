import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';

customTextField({TextEditingController? controller, String? text, FormFieldValidator<String>? validator, bool? obscureText, Widget? suffixIcon}) {
  return Padding(
    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
    child: TextFormField(
      style: const TextStyle(color: ColorConstant.black),
      cursorColor: ColorConstant.black,
      obscureText: obscureText ?? false,
      validator: validator,
      controller: controller,
      autocorrect: true,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        labelText: text ?? '',
        labelStyle: const TextStyle(color: ColorConstant.black, fontSize: 18),
        errorStyle: const TextStyle(color: ColorConstant.red, fontSize: 15),
        focusedErrorBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: ColorConstant.black, width: 2.0)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: ColorConstant.red)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: ColorConstant.black)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: ColorConstant.black, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: ColorConstant.black),
        ),
      ),
    ),
  );
}
