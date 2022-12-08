import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';

customTextField(
    {TextEditingController? controller,
    String? text,
    FormFieldValidator<String>? validator,
    bool? obscureText,
    Widget? suffixIcon,
    Widget? prefixIcon,
    ValueChanged<String>? onChanged}) {
  return Padding(
    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
    child: TextFormField(
      onChanged: onChanged,
      // style: const TextStyle(color: ColorConstant.black),
      obscureText: obscureText ?? false,
      validator: validator,
      controller: controller,
      autocorrect: true,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: text ?? '',
        labelStyle: const TextStyle(fontSize: 18),
        errorStyle: const TextStyle(color: ColorConstant.red, fontSize: 15),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: ColorConstant.black, width: 2.0)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: ColorConstant.red)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: ColorConstant.black)),
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

chatScreenTextField({
  TextEditingController? controller,
  ValueChanged<String>? onChanged,
  GestureTapCallback? onTap,
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? hintText,
}) {
  return TextField(
    onTap: onTap,
      cursorHeight: 24,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 3,
      controller: controller,
      cursorColor: ColorConstant.blue,
      decoration: InputDecoration(
        hintText: hintText,
          contentPadding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(),
          )),
      onChanged: onChanged);
}
