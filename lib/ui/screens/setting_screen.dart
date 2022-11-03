import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/constant/image_constant.dart';
import 'package:tinder_app_new/core/constant/text_style_constant.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/setting_screen_view_model.dart';

import '../../core/provider/theme_changer.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  SettingScreenViewModel? model;
  bool valueTheme = true;

  @override
  Widget build(BuildContext context) {
    Future<void> onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
      (value) ? themeNotifier.setTheme(darkTheme) : themeNotifier.setTheme(lightTheme);
      var prefs = await SharedPreferences.getInstance();
      prefs.setBool('darkMode', value);
    }

    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return BaseView<SettingScreenViewModel>(builder: (buildContext, model, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorConstant.pinkAccent,
        ),
        body: CustomPaint(
          painter: CurvePainter(),
          child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 1,
              child: Column(
                children: [
                  model.image != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(model.image ?? ''),
                          backgroundColor: Colors.white,
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
                  Text("${model.name.toString()} ,${model.gender.toString()}", style: TextStyleConstant.settingNameStyle),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.009),
                  Text(model.email.toString(), style: TextStyleConstant.settingEmailStyle),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      iconBtn(child: Icon(Icons.settings, color: ColorConstant.grey600), text: 'SETTING', color: ColorConstant.white),
                      Container(
                        padding: const EdgeInsets.only(top: 67),
                        child: Column(
                          children: [
                            iconBtn(
                                child: const Icon(Icons.camera_alt, color: ColorConstant.white, size: 32),
                                text: 'ADD MEDIA',
                                color: ColorConstant.orange,
                                maxRadius: 35,
                                minRadius: 35),
                          ],
                        ),
                      ),
                      iconBtn(
                          child: Icon(Icons.edit_note_outlined, color: ColorConstant.grey600, size: 25),
                          text: 'EDIT INFO',
                          color: ColorConstant.white),
                      GestureDetector(
                          onTap: () {},
                          child: CupertinoSwitch(
                              value: valueTheme,
                              onChanged: (bool? value) {
                                valueTheme = value!;
                                setState(() {});
                                onThemeChanged(value, themeNotifier);
                              }))
                    ],
                  ),
                ],
              )),
        ),
      );
    }, onModelReady: (model) {
      this.model = model;
      model.getDate();
    });
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = ColorConstant.pinkAccent;
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

Widget iconBtn({required Widget child, required String text, required Color color, double? minRadius, double? maxRadius}) {
  return Column(
    children: [
      CircleAvatar(
        backgroundColor: color,
        minRadius: minRadius ?? 26,
        maxRadius: maxRadius ?? 26,
        child: child,
      ),
      const SizedBox(height: 5),
      Text(text, style: const TextStyle(color: ColorConstant.white, fontWeight: FontWeight.w500))
    ],
  );
}

/*class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = ColorConstant.pinkAccent;
    paint.style = PaintingStyle.fill;
    var path = Path();

    path.moveTo(0, size.height * 0.25);
    path.quadraticBezierTo(size.width / 2, size.height / 2.9, size.width, size.height * 0.25);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}*/
