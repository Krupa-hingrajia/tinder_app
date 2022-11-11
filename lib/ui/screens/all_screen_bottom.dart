import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/all_screen_bottom_view_model.dart';

class AllScreenBottom extends StatefulWidget {
  const AllScreenBottom({super.key});

  @override
  State<StatefulWidget> createState() => AllScreenBottomState();
}

class AllScreenBottomState extends State<AllScreenBottom> {
  AllScreenBottomViewModel? model;

  void _onItemTapped(int index) {
    setState(() {
      model!.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AllScreenBottomViewModel>(builder: (buildContext, model, child) {
      return Scaffold(
        body: Center(
          child: AllScreenBottomViewModel.pages.elementAt(model.selectedIndex),
        ),
        bottomNavigationBar: bottomNavigationBar,
      );
    }, onModelReady: (model) {
      this.model = model;
    });
  }

  Widget get bottomNavigationBar {
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          gradient: LinearGradient(
            colors: <Color>[ColorConstant.yellowLight, ColorConstant.greenLight],
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: model!.selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          iconSize: 32,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Icon(model!.selectedIndex == 0 ? Icons.home : Icons.home_outlined, color: Colors.black),
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Icon(model!.selectedIndex == 1 ? Icons.chat : Icons.chat_outlined, color: Colors.black),
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Icon(model!.selectedIndex == 2 ? Icons.person : Icons.person_outline, color: Colors.black),
                ),
                label: ''),
          ],
        ));
  }
}
