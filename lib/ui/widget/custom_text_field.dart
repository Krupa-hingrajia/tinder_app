import 'package:flutter/material.dart';

customTextField(
    {TextEditingController? controller,
    String? text,
    FormFieldValidator<String>? validator,
    bool? obscureText,
    Widget? suffixIcon}) {
  return Padding(
    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
    child: TextFormField(
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      obscureText: obscureText ?? false,
      validator: validator,
      controller: controller,
      autocorrect: true,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        labelText: text ?? '',
        labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
        errorStyle: const TextStyle(color: Colors.white, fontSize: 15),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: Colors.white)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    ),
  );
}
