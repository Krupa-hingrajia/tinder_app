import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/all_screen_bottom_view_model.dart';

class AllScreenBottom extends StatefulWidget {
  const AllScreenBottom({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AllScreenBottomState createState() => _AllScreenBottomState();
}

class _AllScreenBottomState extends State<AllScreenBottom> {
  AllScreenBottomViewModel? model;

  @override
  Widget build(BuildContext context) {
    return BaseView<AllScreenBottomViewModel>(
      builder: (buildContext, model, child) {
        return Scaffold(
          body: model.pages[model.pageIndex],
          bottomNavigationBar: buildMyNavBar(context),
        );
      },
      onModelReady: (model) {
        this.model = model;
      },
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.080,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[ColorConstant.yellowLight, ColorConstant.greenLight],
          ),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              enableFeedback: false,
              onPressed: () {
                model!.pageIndex = 0;
                setState(() {});
              },
              icon: model!.pageIndex == 0
                  ? const Icon(Icons.home_filled, size: 35)
                  : const Icon(Icons.home_outlined, size: 35)),
          IconButton(
              enableFeedback: false,
              onPressed: () {
                model!.pageIndex = 1;
                setState(() {});
              },
              icon:
                  model!.pageIndex == 1 ? const Icon(Icons.chat, size: 35) : const Icon(Icons.chat_outlined, size: 35)),
          IconButton(
              enableFeedback: false,
              onPressed: () {
                model!.pageIndex = 2;
                setState(() {});
              },
              icon: model!.pageIndex == 2
                  ? const Icon(Icons.person, size: 35)
                  : const Icon(Icons.person_outline, size: 35)),
        ],
      ),
    );
  }
}
