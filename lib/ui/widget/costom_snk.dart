import 'package:flutter/material.dart';

coustomSnk({required BuildContext context, required String text}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.white,
    duration: const Duration(seconds: 3),
    shape: const RoundedRectangleBorder(),
    content: Text(text ?? '', style: const TextStyle(color: Colors.black, fontSize: 16, letterSpacing: 0.5)),
  ));
}
