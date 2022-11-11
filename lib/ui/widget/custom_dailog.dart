import 'package:flutter/material.dart';

customDialog({
  required BuildContext context,
  required Widget content,
  required String title,
  bool? barrierDismissible,
  required VoidCallback editOnPressed,
}) {
  return showDialog(
    barrierDismissible: barrierDismissible!,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        buttonPadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.only(right: 0, left: 0, top: 16, bottom: 0),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.blue))),
          TextButton(onPressed: editOnPressed, child: const Text('Edit', style: TextStyle(color: Colors.blue))),
        ],
        title: Text(title, style: const TextStyle(fontSize: 20)),
        content: content,
      );
    },
  );
}
