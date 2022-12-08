import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/model/cards_model.dart';
import 'package:tinder_app_new/core/model/message_model.dart';
import 'package:tinder_app_new/core/routing/routes.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/chat_screen_view_model/chat_screen_view_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatScreenViewModel? model;
  String? messageId;
  List<ProfilePicture> profilePicture = [];
  List<ChatRoomId> chatRoomID = [];
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  List<dynamic> statusList = [];
  List<dynamic> confirmList = [];
  String? userId;
  String? name;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefValue) => {
          setState(() {
            userId = prefValue.getString('id');
            name = prefValue.getString('name');
          })
        });
  }

  getStatusList() async {
    await FirebaseFirestore.instance.collection("Users").get().then((querySnapshot) async {
      var index = querySnapshot.docs.indexWhere((element) => element.get('id') == userId);
      List<dynamic> data = querySnapshot.docs[index].get('like_list');
      for (var element in data) {
        if (element['status'] == "confirm") {
          confirmList.add(element['id']);
        }
      }
    });
    getUsers();
    setState(() {});
  }

  getUsers() async {
    var data = await firebase.collection('Users').where('id', whereIn: confirmList).get();
    profilePicture.clear();
    for (int i = 0; i < data.docs.length; i++) {
      ProfilePicture model = ProfilePicture(data.docs[i].data()['image_url'], data.docs[i].data()['name'],
          data.docs[i].data()['gender'], data.docs[i].data()['id'], data.docs[i].data()['like_list']);
      profilePicture.add(model);
    }
  }

  setId(int index) async {
    String id = firebase.collection("ChatRoom").doc().id;
    messageId = id;
    firebase.collection('ChatRoom').doc(id).set({
      'senderId': userId,
      'receiverId': profilePicture[index].id,
      'id': id,
      'in_chat_receiver': false,
      'in_chat_sender': false
    });
  }

  chatRoomId(int index) async {
    var data = await firebase.collection('ChatRoom').get();
    chatRoomID.clear();
    for (int i = 0; i < data.docs.length; i++) {
      ChatRoomId model =
          ChatRoomId(data.docs[i].data()['senderId'], data.docs[i].data()['receiverId'], data.docs[i].data()['id']);
      chatRoomID.add(model);
    }

    /// CONDITION...
    int findIndex = chatRoomID.indexWhere((e) =>
        (e.receiverId == profilePicture[index].id && e.senderId == userId) ||
        (e.receiverId == userId && e.senderId == profilePicture[index].id));
    if (findIndex == -1) {
      setId(index);
    } else {
      messageId = chatRoomID[findIndex].id;
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
              )),
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 5, top: 10, left: 10, right: 10),
                child: TextField(
                  cursorHeight: 24,
                  controller: model.searchController,
                  cursorColor: ColorConstant.blue,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(10, 15, 20, 15),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(),
                      )),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: getUsers(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: profilePicture.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (model.searchController.text.isEmpty) {
                              return GestureDetector(
                                onTap: () async {
                                  /// PERSONAL USER CHAT SCREEN
                                  await chatRoomId(index);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushNamed(context, Routes.personalChatScreen,
                                      arguments: PersonalMessageArguments(
                                          title: profilePicture[index].userName,
                                          profileId: profilePicture[index].id,
                                          messageId: messageId));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10, left: 10, bottom: 5),
                                  height: MediaQuery.of(context).size.height * 0.084,
                                  width: double.infinity,
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(context, Routes.requestSenderScreen,
                                              arguments: MessageArguments(
                                                  image: profilePicture[index].imageURL.toString(),
                                                  title: profilePicture[index].userName));
                                        },
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            height: MediaQuery.of(context).size.height * 0.078,
                                            width: MediaQuery.of(context).size.width * 0.16,
                                            fit: BoxFit.cover,
                                            imageUrl: profilePicture[index].imageURL.toString(),
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(color: Colors.blue),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(profilePicture[index].userName.toString(),
                                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                                          Text(profilePicture[index].gender.toString())
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            } else if (profilePicture[index]
                                    .userName
                                    .toString()
                                    .toLowerCase()
                                    .contains(model.searchController.text) ||
                                profilePicture[index]
                                    .userName
                                    .toString()
                                    .toUpperCase()
                                    .contains(model.searchController.text)) {
                              return GestureDetector(
                                onTap: () {
                                  /// PERSONAL USER CHAT SCREEN
                                  Navigator.pushNamed(context, Routes.personalChatScreen,
                                      arguments: PersonalMessageArguments(title: profilePicture[index].userName));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10, left: 10, bottom: 5),
                                  height: MediaQuery.of(context).size.height * 0.084,
                                  width: double.infinity,
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(context, Routes.requestSenderScreen,
                                              arguments: MessageArguments(
                                                  image: profilePicture[index].imageURL.toString(),
                                                  title: profilePicture[index].userName));
                                        },
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            height: MediaQuery.of(context).size.height * 0.078,
                                            width: MediaQuery.of(context).size.width * 0.16,
                                            fit: BoxFit.cover,
                                            imageUrl: profilePicture[index].imageURL.toString(),
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(color: Colors.blue),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(profilePicture[index].userName.toString(),
                                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                                          Text(profilePicture[index].gender.toString())
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                             }
                          });
                    }
                    return const Center(child: CircularProgressIndicator(color: ColorConstant.greenLight));
                  },
                ),
              )
            ],
          ),
        );
      },
      onModelReady: (model) {
        this.model = model;
        // chatRoomId(index);
        getStatusList();
      },
    );
  }
}
