import 'package:flutter/material.dart';

dropDownWidget({
  String? dropDownValue,
  double? height,
  double? width,
  Icon? icon,
  double? topHeight,
  EdgeInsets? padding,
  List<String>? categoryList,
  String? hintText,
  BoxDecoration? decoration,
  required BuildContext context,
  ValueChanged<String?>? onChanged,
}) {
  return Container(
    height: height,
    width: width ?? double.infinity,
    margin: EdgeInsets.only(left: 16, right: 16, top: topHeight ?? 25),
    decoration: decoration ?? BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all()
  ),
    child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: DropdownButton(
          value: dropDownValue,
          isExpanded: true,
          icon: icon ?? const Icon(Icons.keyboard_arrow_down_sharp, size: 25),
          onChanged: onChanged,
          underline: Container(),
          hint: Text(
            hintText!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          items: categoryList!
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Padding(
                        padding: padding ??  const EdgeInsets.all(8.0),
                        child: Text(e, style: const TextStyle(fontSize: 16))),
                  ))
              .toList(),
        )),
  );
}
