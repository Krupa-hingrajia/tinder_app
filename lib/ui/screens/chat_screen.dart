import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';

import '../../core/view_model/screens_view_model/chat_screen_view_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatScreenViewModel? model;

  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  dynamic data;

  readFeeds() {
    var notesItemCollection = _firebase.collection('Users').where('isFavourite', isEqualTo: true).get();
    notesItemCollection.then((value) {
      value.docs.where((element) => element.get('isFavourite'));
    });
    return notesItemCollection;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readFeeds();
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
                colors: <Color>[ColorConstant.yellowLight, ColorConstant.greenLight],
              )),
            ),
          ),
          body: Column(
            children: [
              /*FutureBuilder(
                future: readFeeds(),
                builder: (BuildContext context, snapshot) {
                  return ListView.builder(
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return const Text('data');
                      });
                }),*/
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () async {
                      await model.showNotification();
                    },
                    child: const Text('PRESS ON')),
              )
            ],
          ),
        );
      },
      onModelReady: (model) {
        this.model = model;
        model.localNotification();
      },
    );
  }
}
