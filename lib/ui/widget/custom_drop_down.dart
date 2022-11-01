import 'package:flutter/material.dart';

dropDownWidget({
  String? dropDownValue,
  double? height,
  List<String>? categoryList,
  String? hintText,
  required BuildContext context,
  ValueChanged<String?>? onChanged,
}) {
  return Container(
    height: height,
    width: double.infinity,
    margin: const EdgeInsets.only(left: 16, right: 16, top: 25),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
    child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton(
          value: dropDownValue,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_sharp, color: Colors.black, size: 25),
          onChanged: onChanged,
          underline: Container(),
          hint: Text(
            hintText!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          items: categoryList!
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(e, style: const TextStyle(fontSize: 16, color: Colors.black))),
                  ))
              .toList(),
        )),
  );
}
