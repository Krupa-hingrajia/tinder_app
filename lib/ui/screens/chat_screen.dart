import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';

import '../../core/model/cards_model.dart';
import '../../core/view_model/screens_view_model/chat_screen_view_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  ChatScreenViewModel? model;
  List<ProfilePicture> profilePicture = [];

  @override
  void initState() {
    super.initState();
  }

  getUsers() async {
    // list.clear();
    var data = await firebase.collection('Users').where('isFavourite', isEqualTo: true).get();
    for (int i = 0; i < data.docs.length; i++) {
      ProfilePicture model = ProfilePicture(data.docs[i].data()['image_url'], data.docs[i].data()['name'], data.docs[i].data()['gender'],
          data.docs[i].data()['id'], data.docs[i].data()['isFavourite']);
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
            body: FutureBuilder(
              future: getUsers(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                      itemCount: profilePicture.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            title: Text(profilePicture[index].userName.toString()),
                            subtitle: Text(profilePicture[index].gender.toString()),
                            leading: Icon(Icons.add));
                      });
                }
                return const Center(child: CircularProgressIndicator(color: ColorConstant.greenLight));
              },
            ));
      },
      onModelReady: (model) {
        this.model = model;
      },
    );
  }
}
