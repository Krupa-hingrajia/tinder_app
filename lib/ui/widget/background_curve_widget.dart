import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';

class BackGroundCurveWidget extends StatelessWidget {
  const BackGroundCurveWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 350,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(64),
            bottomRight: Radius.circular(64),
          ),
        ),
        gradient: LinearGradient(
          colors: <Color>[ColorConstant.yellowLight, ColorConstant.greenLight],
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.only(top: 46.0, left: 20.0),
        child: Text(
          'Tinder',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            color: ColorConstant.black,
            fontSize: 36,
          ),
        ),
      ),
    );
  }
}
