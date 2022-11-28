import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tinder_app_new/core/view_model/base_model.dart';

class PersonalChatScreenViewModel extends BaseModel {
  TextEditingController sendController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

/*  sendMessage() {
    return firestore
        .collection("ChatRoom")
        .doc()
        .collection('message')
        .doc()
        .set({
          'content': sendController.text,
        })
        .then((value) => print("User data Added"))
        .catchError((error) => print("User couldn't be added."));
  }*/
}
