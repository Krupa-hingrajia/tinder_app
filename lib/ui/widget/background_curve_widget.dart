import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';

class BackGroundCurveWidget extends StatefulWidget {
  const BackGroundCurveWidget({Key? key}) : super(key: key);

  @override
  State<BackGroundCurveWidget> createState() => _BackGroundCurveWidgetState();
}

class _BackGroundCurveWidgetState extends State<BackGroundCurveWidget> {
  var prefs = SharedPreferences.getInstance();

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
          )),
      child: const Padding(
        padding: EdgeInsets.only(top: 57.0, left: 20.0, right: 20.0),
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

  Future<bool> getColor() async {
    var pref;
    await SharedPreferences.getInstance().then((prefs) {
      pref = prefs.getBool("darkMode") ?? true;
    });

    return pref;
  }
}
