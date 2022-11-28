import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/constant/image_constant.dart';
import 'package:tinder_app_new/core/constant/text_style_constant.dart';
import 'package:tinder_app_new/core/model/message_model.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/notification_screen_view_model/request_sender_profile_view_model.dart';

// ignore: must_be_immutable
class RequestSenderProfile extends StatefulWidget {
  MessageArguments? messageArguments;

  RequestSenderProfile({Key? key, this.messageArguments}) : super(key: key);

  @override
  State<RequestSenderProfile> createState() => _RequestSenderProfileState();
}

class _RequestSenderProfileState extends State<RequestSenderProfile> {
  RequestSenderProfileViewModel? model;

  @override
  Widget build(BuildContext context) {
    return BaseView<RequestSenderProfileViewModel>(
      builder: (buildContext, model, child) {
        return SafeArea(
          top: true,
          child: Scaffold(
            /*appBar: AppBar(
              title: Text("${widget.messageArguments!.title.toString()}'s profile"),
              flexibleSpace: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                colors: <Color>[ColorConstant.yellowLight, ColorConstant.greenLight],
              ))),
            ),*/
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      CachedNetworkImage(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: widget.messageArguments!.image.toString(),
                        placeholder: (context, url) =>
                        const Padding(
                          padding:  EdgeInsets.all(180),
                          child:  CircularProgressIndicator(color: Colors.blue),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14.0, top: 16.0),
                          child: SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.asset(ImageConstant.back, color: Colors.white.withOpacity(.5))),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 12, bottom: 12),
                      child: Row(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${widget.messageArguments!.title.toString()}, 20",
                                style: TextStyleConstant.requestSenderValue),
                            Text("Flutter Developer", style: TextStyleConstant.requestSenderKey),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                            width: 55,
                            height: 55,
                            child: Card(
                                elevation: 4,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(ImageConstant.direct),
                                )))
                      ]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text('About', style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.w500, fontSize: 20)),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                        'We have a new hot shot — a dating app 👩‍❤️‍👨 It’s pretty hard to meet your partner offline, right? 💜 Thanks God now we have dating apps 😅',
                        style: TextStyleConstant.requestSenderKeyAbout),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Interests',
                        style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.w500, fontSize: 20)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Wrap(
                      spacing: 5,
                      direction: Axis.horizontal,
                      children: [
                        _buildChip('Music', Colors.cyan.shade300),
                        _buildChip('Photo', Colors.orangeAccent.shade200),
                        _buildChip('Art History', Colors.purpleAccent.shade100),
                        _buildChip('Design', Colors.pinkAccent.shade100),
                        _buildChip('Art Film', Colors.redAccent.shade100),
                        _buildChip('Traveling', Colors.blue.shade100),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      onModelReady: (model) {
        this.model = model;
      },
    );
  }

  Widget _buildChip(String label, Color color) {
    return Chip(
      labelPadding: const EdgeInsets.all(2.0),
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
      backgroundColor: color,
      elevation: 4.0,
      shadowColor: Colors.grey[60],
      padding: const EdgeInsets.all(8.0),
    );
  }
}
