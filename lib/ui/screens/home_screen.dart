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
  String? downloadURL;

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeScreenViewModel>(builder: (buildContext, model, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: const [
            BackGroundCurveWidget(),
            CardsStackWidget(),
          ],
        ),
      );
      /* return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstant.pinkAccent,
        ),
        body: FutureBuilder(
          future: loadImage(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text(
                "Something went wrong",
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              */ /*return ListView.builder(
                  itemCount: snapshot.data,
                  itemBuilder: (BuildContext context, int index) {
                    return Image.network(
                      snapshot.data.toString(),
                    );
                  });*/ /*
              return Image.network(
                snapshot.data.toString(),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      );*/
    }, onModelReady: (model) {
      this.model = model;
    });
  }
}
