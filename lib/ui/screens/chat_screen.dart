import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/constant/image_constant.dart';
import 'package:tinder_app_new/core/model/message_model.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';

import '../../core/model/cards_model.dart';
import '../../core/view_model/screens_view_model/chat_screen_view_model.dart';

class ChatScreen extends StatefulWidget {
  MessageArguments? messageArguments;

  ChatScreen({Key? key, this.messageArguments}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatScreenViewModel? model;
  List<ProfilePicture> profilePicture = [];
  FirebaseFirestore firebase = FirebaseFirestore.instance;

  getUsers() async {
    var data = await firebase.collection('Users').where('isFavourite', isEqualTo: true).get();
    for (int i = 0; i < data.docs.length; i++) {
      ProfilePicture model = ProfilePicture(data.docs[i].data()['image_url'], data.docs[i].data()['name'],
          data.docs[i].data()['gender'], data.docs[i].data()['id'], data.docs[i].data()['isFavourite']);
      profilePicture.add(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ChatScreenViewModel>(
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
            /*FutureBuilder(
            future: getUsers(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                    itemCount: profilePicture.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: Text(profilePicture[index].userName.toString()),
                          subtitle: Text(profilePicture[index].gender.toString()),
                          leading: const Icon(Icons.add));
                    });
              }
              return const Center(child: CircularProgressIndicator(color: ColorConstant.greenLight));
            },
          ),*/
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
