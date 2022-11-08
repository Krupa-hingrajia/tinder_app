import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/constant/image_constant.dart';
import 'package:tinder_app_new/core/constant/text_style_constant.dart';
import 'package:tinder_app_new/core/model/profile_model.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/profile_screen_view_model.dart';
import 'package:tinder_app_new/ui/screens/setting_screen.dart';

class ProfileScreen extends StatefulWidget {
  // UserArguments? userArguments;

  const ProfileScreen({Key? key, /*this.userArguments*/}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileScreenViewModel? model;

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileScreenViewModel>(builder: (buildContext, model, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFc1f8b3),
        ),
        body: CustomPaint(
          painter: CurvePainter(),
          child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 1,
              child: Column(children: [
                model.image != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(model.image ?? ''),
                        // backgroundColor: Colors.white,
                        maxRadius: MediaQuery.of(context).size.height * 0.08,
                        minRadius: MediaQuery.of(context).size.width * 0.08,
                      )
                    : CircleAvatar(
                        backgroundImage: const AssetImage(ImageConstant.user),
                        backgroundColor: Colors.white,
                        maxRadius: MediaQuery.of(context).size.height * 0.08,
                        minRadius: MediaQuery.of(context).size.width * 0.08,
                      ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text("${model.name}, ${model.gender}", style: TextStyleConstant.settingNameStyle),
                SizedBox(height: MediaQuery.of(context).size.height * 0.009),
                Text("${model.email}", style: TextStyleConstant.settingEmailStyle),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        /// SETTING SCREEN.
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingScreen()));
                      },
                      child: iconBtn(
                          child: const Icon(Icons.settings, color: ColorConstant.black),
                          text: 'SETTING',
                          color: ColorConstant.yellowLight),
                    ),
                    Container(
                        padding: const EdgeInsets.only(top: 67),
                        child: Column(children: [
                          iconBtn(
                              child: const Icon(Icons.camera_alt, color: ColorConstant.black, size: 32),
                              text: 'ADD MEDIA',
                              color: ColorConstant.yellowLight,
                              maxRadius: 65,
                              minRadius: 65),
                        ])),
                    iconBtn(
                        child: const Icon(Icons.edit_note_outlined, color: ColorConstant.black, size: 25),
                        text: 'EDIT INFO',
                        color: ColorConstant.yellowLight),
                  ],
                ),
              ])),
        ),
      );
    }, onModelReady: (model) {
      this.model = model;
      model.getDate();
      model.updateUI();
    });
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = ColorConstant.greenLight;
    paint.style = PaintingStyle.fill;
    var path = Path();

    path.moveTo(0, size.height * 0.50);
    path.quadraticBezierTo(size.width / 1.9, size.height / 1.52, size.width, size.height * 0.50);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

Widget iconBtn(
    {required Widget child, required String text, required Color color, double? minRadius, double? maxRadius}) {
  return Column(
    children: [
      Container(
        height: minRadius ?? 52,
        width: maxRadius ?? 52,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: <Color>[ColorConstant.orange, ColorConstant.yellowLight])),
        child: child,
      ),
      const SizedBox(height: 5),
      Text(text, style: const TextStyle(color: ColorConstant.black, fontWeight: FontWeight.w500))
    ],
  );
}
