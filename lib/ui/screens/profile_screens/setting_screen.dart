import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_app_new/core/provider/theme_changer.dart';
import 'package:tinder_app_new/core/routing/routes.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/profile_screen_view_models/setting_screen_view_model.dart';
import 'package:tinder_app_new/ui/widget/custom_drop_down.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  SettingScreenViewModel? model;
  bool? valueTheme;

  @override
  Widget build(BuildContext context) {
    Future<void> onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
      (value) ? themeNotifier.setTheme(darkTheme) : themeNotifier.setTheme(lightTheme);
      var prefs = await SharedPreferences.getInstance();
      prefs.setBool('darkMode', value);
    }

    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return BaseView<SettingScreenViewModel>(
      builder: (buildContext, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('SETTING'),
            centerTitle: true,
            flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
              colors: <Color>[ColorConstant.yellowLight, ColorConstant.greenLight],
            ))),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_outlined)),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 12.0, right: 10.0, left: 10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Change Theme', style: TextStyle(fontSize: 20)),
                    const Spacer(),
                    Switch(
                        value: valueTheme ?? true,
                        onChanged: (bool? value) {
                          valueTheme = value!;
                          setState(() {});
                          onThemeChanged(value, themeNotifier);
                        })
                  ],
                ),
                const SizedBox(height: 2),
                const Divider(),
                Row(children: [
                  const Text('Gender', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  const Spacer(),
                  dropDownWidget(
                    context: context,
                    topHeight: 0,
                    decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
                    icon: const Icon(Icons.arrow_forward_ios, size: 20),
                    width: MediaQuery.of(context).size.width * 0.29,
                    height: MediaQuery.of(context).size.height * 0.062,
                    categoryList: model.dropDnwList,
                    hintText: model.genderGet ?? 'All',
                    dropDownValue: model.selectValue,
                    onChanged: (value) {
                      model.selectValue = value;
                      model.setDate();
                      setState(() {});
                    },
                  ),
                ]),
                const Spacer(),
                const Divider(),
                IconButton(
                    onPressed: () {
                      /// LOG OUT
                      Navigator.pushNamed(context, Routes.loginScreen);
                    },
                    icon: const Icon(Icons.logout, size: 28)),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
      onModelReady: (model) {
        model.getDate();
        this.model = model;
      },
    );
  }
}
