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

  readFeeds() {
    var notesItemCollection = _firebase.collection('Users').where('isFavourite', isEqualTo: true).get();
    notesItemCollection.then((value) {
      value.docs.where((element) => element.get('isFavourite'));
    });
    print('______________${notesItemCollection}');

    return notesItemCollection;
  }

/*  getFavUser() async {
    final CollectionReference _mainCollection = _firebase.collection('Sales');
    CollectionReference getUser = await firebase.collection('Users').where('isFavourite', isEqualTo: true).get();
    print("**************____________************${getUser}");
    return getUser.s;
  }*/

  @override
  void initState() {
    // TODO: implement initState
    readFeeds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages'), backgroundColor: ColorConstant.pinkAccent),
      body: FutureBuilder(
          future: readFeeds(),
          builder: (BuildContext context, snapshot) {
            return ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return Text('data');
                });
          }),
    );
  }
}
