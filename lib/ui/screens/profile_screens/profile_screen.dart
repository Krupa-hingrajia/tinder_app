import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/constant/image_constant.dart';
import 'package:tinder_app_new/core/constant/text_style_constant.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/profile_screen_view_models/profile_screen_view_model.dart';
import 'package:tinder_app_new/ui/screens/profile_screens/add_media_screen.dart';
import 'package:tinder_app_new/ui/screens/profile_screens/edit_profile_screen.dart';
import 'package:tinder_app_new/ui/screens/profile_screens/setting_screen.dart';
import 'package:tinder_app_new/ui/widget/carousel_container.dart';
import 'package:tinder_app_new/ui/widget/custom_btn.dart';
import 'package:tinder_app_new/ui/widget/custom_dailog.dart';

class ProfileScreen extends StatefulWidget {
  // UserArguments? userArguments;
  const ProfileScreen({
    Key? key,
    /*this.userArguments*/
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileScreenViewModel? model;
  String? name;
  String? email;
  String? image;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefValue) => {
          setState(() {
            name = prefValue.getString('name');
            email = prefValue.getString('email');
            image = prefValue.getString('image');
            print('NAMEEEEEEEE :: $name');
            print('EMAILLLLLLL :: $email');
            print('IMAGEEEEEEE :: $image');
          })
        });
  }

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
                image != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(image ?? ''),
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
                Text("$name", style: TextStyleConstant.settingNameStyle),
                SizedBox(height: MediaQuery.of(context).size.height * 0.009),
                Text("$email", style: TextStyleConstant.settingEmailStyle),
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
                    GestureDetector(
                      onTap: () {
                        /// ADD MEDIA.
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMediaScreen()));
                      },
                      child: Container(
                          padding: const EdgeInsets.only(top: 67),
                          child: Column(children: [
                            iconBtn(
                                child: const Icon(Icons.camera_alt, color: ColorConstant.black, size: 32),
                                text: 'ADD MEDIA',
                                color: ColorConstant.yellowLight,
                                maxRadius: 65,
                                minRadius: 65),
                          ])),
                    ),
                    GestureDetector(
                      onTap: () {
                        /// EDIT PROFILE
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
                      },
                      child: iconBtn(
                          child: const Icon(Icons.edit_note_outlined, color: ColorConstant.black, size: 25),
                          text: 'EDIT',
                          color: ColorConstant.yellowLight),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 180.0,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                  items: [
                    carouselContainer(
                        context: context,
                        icon: Icons.heart_broken_sharp,
                        iconColor: Colors.green,
                        textOne: "Increase Your Changes",
                        textTwo: 'Get unlimited likes with Tinder Plus!'),
                    carouselContainer(
                        context: context,
                        icon: Icons.flash_on_outlined,
                        iconColor: Colors.purpleAccent,
                        textOne: "Get Matches Faster",
                        textTwo: 'Boost your profile once a month!'),
                    carouselContainer(
                        context: context,
                        icon: Icons.key_rounded,
                        iconColor: Colors.orangeAccent,
                        textOne: "Control Your Profile",
                        textTwo: 'Limit what others see with Tinder'),
                    carouselContainer(
                        context: context,
                        icon: Icons.local_fire_department,
                        iconColor: Colors.orangeAccent,
                        textOne: "Get Tinder Gold",
                        textTwo: 'See who Likes you & more!'),
                  ],
                ),
                customButton(
                  text: 'MY TINDER PLUS',
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.height * 0.24,
                  onPressed: () {
                    /// MY TINDER PLUS!
                  },
                )
              ])),
        ),
      );
    }, onModelReady: (model) {
      this.model = model;
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
