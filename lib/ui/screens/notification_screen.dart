import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/model/message_model.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/notification_screen_view_model.dart';

// ignore: must_be_immutable
class NotificationScreen extends StatefulWidget {
  MessageArguments? messageArguments;

  NotificationScreen({Key? key, this.messageArguments}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationScreenViewModel? model;

  @override
  Widget build(BuildContext context) {
    return BaseView<NotificationScreenViewModel>(
      builder: (buildContext, model, child) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Messages'),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  colors: <Color>[ColorConstant.greenLight, ColorConstant.greenLight],
                )),
              ),
            ),
            body: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                child: Column(children: [
                  Row(children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.messageArguments!.image.toString()),
                      backgroundColor: Colors.white,
                      maxRadius: MediaQuery.of(context).size.height * 0.04,
                      minRadius: MediaQuery.of(context).size.width * 0.04,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        children: [
                          Text('${widget.messageArguments?.body}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const Text('requested to follow you',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                        ],
                      ),
                    )
                  ])
                ]))
            );
      },
      onModelReady: (model) {
        this.model = model;
        print('TITLE ::> ${widget.messageArguments!.image}');
        // print('BODY ::> ${widget.messageArguments!.body}');
      },
    );
  }
}
