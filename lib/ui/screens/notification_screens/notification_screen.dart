import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/model/cards_model.dart';
import 'package:tinder_app_new/core/model/message_model.dart';
import 'package:tinder_app_new/core/routing/routes.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/notification_screen_view_model/notification_screen_view_model.dart';

// ignore: must_be_immutable
class NotificationScreen extends StatefulWidget {
  MessageArguments? messageArguments;

  NotificationScreen({Key? key, this.messageArguments}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationScreenViewModel? model;
  List<ProfilePicture> notificationStatus = [];
  List likeList = [];
  List confirmList = [];
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  String? id;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefValue) => {
          setState(() {
            id = prefValue.getString('id');
          })
        });
  }

  getLikeList() async {
    await FirebaseFirestore.instance.collection("Users").get().then((querySnapshot) async {
      var index = querySnapshot.docs.indexWhere((element) => element.get('id') == id);
      List<dynamic> data = querySnapshot.docs[index].get('like_list');
      for (var element in data) {
        if (element['status'] == "send") {
          likeList.add(element['id']);
          print("LIKE LIST $likeList");
        }
      }
    });
    sendNotification();
    setState(() {});
  }

  sendNotification() async {
    var data = await firebase.collection('Users').where('id', whereIn: likeList).get();
    notificationStatus.clear();
    for (int i = 0; i < data.docs.length; i++) {
      ProfilePicture model = ProfilePicture(data.docs[i].data()['image_url'], data.docs[i].data()['name'],
          data.docs[i].data()['gender'], data.docs[i].data()['id'], data.docs[i].data()['like_list']);
      notificationStatus.add(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<NotificationScreenViewModel>(
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
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 5, top: 10, left: 10, right: 10),
                  child: TextField(
                    controller: model.searchController,
                    cursorColor: ColorConstant.blue,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(10, 15, 20, 15),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(),
                        )),
                    cursorHeight: 24,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: sendNotification(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: notificationStatus.length,
                            itemBuilder: (context, index) {
                              if (model.searchController.text.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                  child: Column(
                                    children: [
                                      Row(children: [
                                        GestureDetector(
                                          onTap: () {
                                            /// Request Sender Profile
                                            Navigator.pushNamed(context, Routes.requestSenderScreen,
                                                arguments: MessageArguments(
                                                    image: notificationStatus[index].imageURL.toString(),
                                                    title: notificationStatus[index].userName));
                                          },
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              height: MediaQuery.of(context).size.height * 0.084,
                                              width: MediaQuery.of(context).size.width * 0.17,
                                              fit: BoxFit.cover,
                                              imageUrl: notificationStatus[index].imageURL.toString(),
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(color: Colors.blue),
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        FittedBox(
                                          child: Text("${notificationStatus[index].userName} send a \nmatch request!!",
                                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                          width: 83,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                              onPressed: () {
                                                model.deleteNotification(id!, notificationStatus[index].id.toString());
                                                model.confirmNotification(id!, notificationStatus[index].id.toString());
                                                setState(() {});
                                              },
                                              child: const Text('Confirm')),
                                        ),
                                        const SizedBox(width: 4),
                                        SizedBox(
                                          width: 72,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                                              onPressed: () {
                                                model.deleteNotification(id!, notificationStatus[index].id.toString());
                                                setState(() {});
                                              },
                                              child: const Text('Delete')),
                                        ),
                                      ]),
                                      const Divider(),
                                    ],
                                  ),
                                );
                              } else if (notificationStatus[index]
                                      .userName
                                      .toString()
                                      .toLowerCase()
                                      .contains(model.searchController.text) ||
                                  notificationStatus[index]
                                      .userName
                                      .toString()
                                      .toUpperCase()
                                      .contains(model.searchController.text)) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                  child: Column(
                                    children: [
                                      Row(children: [
                                        GestureDetector(
                                          onTap: () {
                                            /// Request Sender Profile
                                            Navigator.pushNamed(context, Routes.requestSenderScreen,
                                                arguments: MessageArguments(
                                                    image: notificationStatus[index].imageURL.toString(),
                                                    title: notificationStatus[index].userName));
                                          },
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              height: MediaQuery.of(context).size.height * 0.084,
                                              width: MediaQuery.of(context).size.width * 0.17,
                                              fit: BoxFit.cover,
                                              imageUrl: notificationStatus[index].imageURL.toString(),
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(color: Colors.blue),
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        FittedBox(
                                          child: Text("${notificationStatus[index].userName} send a \nmatch request!!",
                                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                          width: 83,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                              onPressed: () {
                                                model.deleteNotification(id!, notificationStatus[index].id.toString());
                                                model.confirmNotification(id!, notificationStatus[index].id.toString());
                                                setState(() {});
                                              },
                                              child: const Text('Confirm')),
                                        ),
                                        const SizedBox(width: 4),
                                        SizedBox(
                                          width: 72,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                                              onPressed: () {
                                                model.deleteNotification(id!, notificationStatus[index].id.toString());
                                                setState(() {});
                                              },
                                              child: const Text('Delete')),
                                        ),
                                      ]),
                                      const Divider(),
                                    ],
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
                ),
              ],
            ));
      },
      onModelReady: (model) {
        this.model = model;
        getLikeList();
        // sendNotification();
      },
    );
  }
}
