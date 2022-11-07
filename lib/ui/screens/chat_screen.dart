import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  dynamic data;

  DocumentSnapshot? snapshot;

  /* void getData() async {
    //use a Async-await function to get the data
    final data = await FirebaseFirestore.instance.collection("Users").doc('BabL30OlN2bfQUnVXK2t').get(); //get the data
    snapshot = data;
  }*/

  @override
  void initState() {
    super.initState();
    //getData();
  }

  @override
  Widget build(BuildContext context) {
    // getData();
    return Scaffold(
      appBar: AppBar(title: const Text('Messages'), backgroundColor: ColorConstant.pinkAccent),
      body: const ListTile(
        title: Text('snapshot!.get([]).toString()'), //ok no errors.
      ),
      /*  body: FutureBuilder(
          future: readFeeds(),
          builder: (BuildContext context, snapshot) {
            return ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return Text('data');
                });
          }),*/
    );
  }
}
