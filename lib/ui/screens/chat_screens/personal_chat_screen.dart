import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/model/message_model.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/chat_screen_view_model/personal_chat_screen_view_model.dart';
import 'package:tinder_app_new/ui/widget/custom_text_field.dart';

// ignore: must_be_immutable
class PersonalChatScreen extends StatefulWidget {
  PersonalMessageArguments personalMessageArguments;

  PersonalChatScreen({Key? key, required this.personalMessageArguments}) : super(key: key);

  @override
  State<PersonalChatScreen> createState() => _PersonalChatScreenState();
}

class _PersonalChatScreenState extends State<PersonalChatScreen> {
  PersonalChatScreenViewModel? model;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? senderId;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefValue) => {
          setState(() {
            senderId = prefValue.getString('id');
          })
        });
  }

  setId() {
    String id = firestore.collection("ChatRoom").doc().id;
    return firestore
        .collection('ChatRoom')
        .doc(id)
        .set({'receiverId': widget.personalMessageArguments.id, 'senderId': senderId});
  }

  @override
  void dispose() {
    super.dispose();
    model!.sendController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<PersonalChatScreenViewModel>(
      builder: (buildContext, model, child) {
        return Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  colors: <Color>[ColorConstant.greenLight, ColorConstant.greenLight],
                )),
              ),
              title: Text(widget.personalMessageArguments.title.toString()),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: const [
                        Text('dataa', style: TextStyle(fontSize: 150)),
                        Text('dataa', style: TextStyle(fontSize: 150)),
                        Text('dataa', style: TextStyle(fontSize: 150)),
                        Text('dataa', style: TextStyle(fontSize: 150)),
                        Text('dataa', style: TextStyle(fontSize: 150)),
                        Text('dataa', style: TextStyle(fontSize: 150)),
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 3, right: 3, bottom: 2),
                    child: chatScreenTextField(
                        onChanged: (value) {
                          model.sendController.text == value;
                          setState(() {});
                        },
                        hintText: 'Type your message....',
                        controller: model.sendController,
                        suffixIcon: model.sendController.text.isEmpty
                            ? const Icon(Icons.image)
                            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // model.sendMessage();
                                    },
                                    child: const Text("Send",
                                        style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1, fontSize: 16)),
                                  ),
                                ),
                              ]),
                        prefixIcon: Container(
                            margin: const EdgeInsets.all(7),
                            decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt, color: Colors.white)))),
              ],
            ));
      },
      onModelReady: (model) {
        this.model = model;
      },
    );
  }
}
