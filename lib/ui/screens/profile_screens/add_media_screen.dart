import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/profile_screen_view_models/add_media_screen_view_model.dart';

class AddMediaScreen extends StatefulWidget {
  const AddMediaScreen({Key? key}) : super(key: key);

  @override
  State<AddMediaScreen> createState() => _AddMediaScreenState();
}

class _AddMediaScreenState extends State<AddMediaScreen> {
  AddMediaScreenViewModel? model;

  @override
  Widget build(BuildContext context) {
    return BaseView<AddMediaScreenViewModel>(
      builder: (buildContext, model, child) {
        return Scaffold(
          body: Center(
            child: Container(
              width: 100,
              height: 100,
              color: Colors.pink,
            ),
          ),
        );
      },
      onModelReady: (model) {
        this.model = model;
      },
    );
  }
}
