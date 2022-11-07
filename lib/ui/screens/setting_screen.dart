import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/routing/routes.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/setting_screen_view_model.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  SettingScreenViewModel? model;

  @override
  Widget build(BuildContext context) {
    return BaseView<SettingScreenViewModel>(
      builder: (buildContext, model, child) {
        return Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: <Color>[ColorConstant.yellowLight, ColorConstant.greenLight],
              )),
            ),
            backgroundColor: ColorConstant.yellowLight,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_outlined)),
            title: const Text('SETTING'),
            centerTitle: true,
          ),
        );
      },
      onModelReady: (model) {
        this.model = model;
      },
    );
  }
}
