import 'package:flutter/material.dart';

carouselContainer(
    {required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String textOne,
    required String textTwo}) {
  return Container(
    width: MediaQuery.of(context).size.height * 0.48,
    color: Colors.transparent,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Icon(icon, size: 50, color: iconColor),
          Text(textOne, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 1.5))
        ]),
        Text(textTwo, style: const TextStyle(fontSize: 18))
      ],
    ),
  );
}
