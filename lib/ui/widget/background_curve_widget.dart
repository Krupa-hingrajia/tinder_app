import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';

class BackGroundCurveWidget extends StatefulWidget {
  const BackGroundCurveWidget({Key? key}) : super(key: key);

  @override
  State<BackGroundCurveWidget> createState() => _BackGroundCurveWidgetState();
}

class _BackGroundCurveWidgetState extends State<BackGroundCurveWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 350,
      decoration: ShapeDecoration(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(64),
            bottomRight: Radius.circular(64),
          ),
        ),
        gradient: LinearGradient(
          colors: <Color>[
            ColorConstant.pinkAccentShade,
            ColorConstant.pinkAccent,
          ],
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.only(top: 46.0, left: 20.0, right: 20.0),
        child: Text(
          'Tinder',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 36,
          ),
        ),
      ),
    );
  }
}
