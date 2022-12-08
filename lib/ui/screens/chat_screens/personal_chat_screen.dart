import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/constant/image_constant.dart';
import 'package:tinder_app_new/core/model/message_model.dart';
import 'package:tinder_app_new/core/utils/send_push_message.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/chat_screen_view_model/personal_chat_screen_view_model.dart';
import 'package:tinder_app_new/ui/widget/custom_text_field.dart';

import '../../../core/model/cards_model.dart';

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
  String content = "";

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefValue) => {
          setState(() {
            senderId = prefValue.getString('id');
          })
        });
  }

  @override
  void dispose() {
    super.dispose();
    model!.sendController.clear();
  }

  updateReceiverId() async {
    await firestore
        .collection("ChatRoom")
        .doc(widget.personalMessageArguments.messageId)
        .collection("message")
        .doc()
        .update({"receiver": true});
  }

  List<ProfilePicture> profilePicture = [];

  getImages() async {
    var data =
        await firestore.collection("ChatRoom").where("id", isEqualTo: widget.personalMessageArguments.messageId).get();
    print(data.docs.first.data());
    bool inThisScreen = data.docs.first.get('in_chat_sender') && data.docs.first.get('in_chat_receiver');
    print(inThisScreen);
  }

  sendMessage() async {
    String id = firestore.collection("message").doc().id;
    return await firestore
        .collection("ChatRoom")
        .doc(widget.personalMessageArguments.messageId)
        .collection('message')
        .doc(id)
        .set({
          'content': model!.sendController.text,
          'senderId': senderId,
          'receiverId': widget.personalMessageArguments.profileId,
          'id': id,
          'send': false,
          'receiver': false,
          'time': DateTime.now(),
        })
        .then((value) async => {
              await firestore
                  .collection("ChatRoom")
                  .doc(widget.personalMessageArguments.messageId)
                  .collection('message')
                  .doc(id)
                  .update({'send': true}),
              await sendPushMessage(widget.personalMessageArguments.profileId, 'Tinder',
                  '$content from ${widget.personalMessageArguments.title}',
                  collectionId: widget.personalMessageArguments.messageId, docId: id),
              setState(() {})
            })
        .catchError((error) => print("User couldn't be added."));
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<PersonalChatScreenViewModel>(
      builder: (buildContext, model, child) {
        return Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[ColorConstant.greenLight, ColorConstant.greenLight])),
              ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_outlined)),
              title: Text(widget.personalMessageArguments.title.toString()),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: firestore
                        .collection('ChatRoom')
                        .doc(widget.personalMessageArguments.messageId)
                        .collection('message')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        List<QueryDocumentSnapshot<Map<String, dynamic>>> data = snapshot.data!.docs;
                        return ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: data[index].get('senderId') == senderId
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.only(top: 12, bottom: 5, left: 12, right: 8),
                                          margin: data[index].get('senderId') == senderId
                                              ? const EdgeInsets.only(top: 2, left: 52, right: 6)
                                              : const EdgeInsets.only(top: 2, left: 6, right: 52),
                                          decoration: BoxDecoration(
                                              color: data[index].get('senderId') == senderId
                                                  ? Colors.greenAccent.withOpacity(.2)
                                                  : Colors.yellowAccent.withOpacity(.2),
                                              borderRadius: BorderRadius.circular(14)),
                                          child: Column(
                                            crossAxisAlignment: data[index].get('senderId') == senderId
                                                ? CrossAxisAlignment.end
                                                : CrossAxisAlignment.start,
                                            children: [
                                              Text(data[index].get('content').toString(),
                                                  style: const TextStyle(fontSize: 18), overflow: TextOverflow.clip),
                                              const SizedBox(height: 2),
                                              data[index].get('senderId') == senderId
                                                  ? Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(DateFormat.jm().format(data[index].get('time').toDate()),
                                                            style: const TextStyle(fontSize: 12)),
                                                        data[index].get('receiver') == true
                                                            ? SizedBox(
                                                                width: 30,
                                                                height: 25,
                                                                child: Image.asset(ImageConstant.doubleCheck))
                                                            : data[index].get('send') == true
                                                                ? SizedBox(
                                                                    width: 18,
                                                                    height: 20,
                                                                    child: Image.asset(ImageConstant.check))
                                                                : const SizedBox(),
                                                      ],
                                                    )
                                                  : Text(DateFormat.jm().format(data[index].get('time').toDate()),
                                                      style: const TextStyle(fontSize: 12))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8)
                                ],
                              );
                            });
                      }
                      return const Center(child: CircularProgressIndicator(color: ColorConstant.greenLight));
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 3, right: 3, bottom: 2),
                    child: Row(
                      children: [
                        Expanded(
                            child: chatScreenTextField(
                                onChanged: (value) {
                                  model.sendController.text == value;
                                  setState(() {});
                                },
                                hintText: 'Type your message....',
                                controller: model.sendController,
                                prefixIcon: Container(
                                    margin: const EdgeInsets.all(7),
                                    decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                                    child: const Icon(Icons.camera_alt, color: Colors.white)))),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () async {
                            // sendPushMessage();
                            model.sendController.text.isEmpty
                                ? model.showToast("Please type message")
                                : await sendMessage();
                            content = model.sendController.text;
                            model.sendController.clear();
                            setState(() {});
                          },
                          child: Container(
                            height: 46,
                            width: 46,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                            child: const Icon(Icons.send, color: Colors.white),
                          ),
                        ),
                      ],
                    )),
              ],
            ));
      },
      onModelReady: (model) async {
        this.model = model;
        getImages();
        print('Message Id :- ${widget.personalMessageArguments.profileId}');
      },
    );
  }
}
