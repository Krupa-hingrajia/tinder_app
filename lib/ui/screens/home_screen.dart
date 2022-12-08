import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/home_screen_view_model.dart';

import '../widget/background_curve_widget.dart';
import 'cards_stack_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenViewModel? model;

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeScreenViewModel>(builder: (buildContext, model, child) {
      return Scaffold(
        body: Stack(
          children: const [
            BackGroundCurveWidget(),
            CardsStackWidget(),
          ],
        ),
      );
    }, onModelReady: (model) async {
      this.model = model;
    });
  }
}
