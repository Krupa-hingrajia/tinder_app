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
          color: ColorConstant.pink,
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
                  ? const Icon(Icons.home_filled, color: Colors.white, size: 35)
                  : const Icon(Icons.home_outlined, color: Colors.white, size: 35)),
          IconButton(
              enableFeedback: false,
              onPressed: () {
                model!.pageIndex = 1;
                setState(() {});
              },
              icon: model!.pageIndex == 1
                  ? const Icon(Icons.chat, color: Colors.white, size: 35)
                  : const Icon(Icons.chat_outlined, color: Colors.white, size: 35)),
          IconButton(
              enableFeedback: false,
              onPressed: () {
                model!.pageIndex = 2;
                setState(() {});
              },
              icon: model!.pageIndex == 2
                  ? const Icon(Icons.person, color: Colors.white, size: 35)
                  : const Icon(Icons.person_outline, color: Colors.white, size: 35)),
        ],
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffC4DFCB),
      child: Center(
        child: Text(
          "Page Number 2",
          style: TextStyle(
            color: Colors.green[900],
            fontSize: 45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
