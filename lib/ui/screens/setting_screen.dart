import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
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
        return Center(
            child: Container(
          height: 100,
          width: 100,
          color: Colors.red,
        ));
      },
      onModelReady: (model) {
        this.model = model;
      },
    );
  }
}
