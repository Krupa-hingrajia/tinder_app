import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';


class NotificationBadge extends StatelessWidget {
  const NotificationBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: const BoxDecoration(
        color: ColorConstant.greenLight,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('T', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
