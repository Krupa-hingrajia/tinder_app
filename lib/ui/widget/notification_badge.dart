import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/constant/image_constant.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Center(child: Image.asset(ImageConstant.tinder)),
    );
  }
}
