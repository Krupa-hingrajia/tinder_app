import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/home_screen_view_model.dart';

import '../widget/background_curve_widget.dart';
import 'cards_stack_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenViewModel? model;
  String? downloadURL;

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeScreenViewModel>(builder: (buildContext, model, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: const [
            BackGroundCurveWidget(),
            CardsStackWidget(),
          ],
        ),
      );
      /* return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstant.pinkAccent,
        ),
        body: FutureBuilder(
          future: loadImage(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text(
                "Something went wrong",
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              */ /*return ListView.builder(
                  itemCount: snapshot.data,
                  itemBuilder: (BuildContext context, int index) {
                    return Image.network(
                      snapshot.data.toString(),
                    );
                  });*/ /*
              return Image.network(
                snapshot.data.toString(),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      );*/
    }, onModelReady: (model) {
      this.model = model;
      getFirebaseImageFolder();
    });
  }

  Future getData() async {
    try {
      await downloadURLExample();
      return downloadURL;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future getFirebaseImageFolder() async {
    final storageRef = FirebaseStorage.instance.ref().child('images');
    storageRef.listAll().then((result) {
      print("result is $result");
    });
  }

  Future<void> downloadURLExample() async {
    downloadURL = await FirebaseStorage.instance.ref().child("Sample.png").getDownloadURL();
    print("*************************${downloadURL.toString()}");
    //print("*************************${ref.getDownloadURL()}");
    // return ref.getDownloadURL();
  }

  Future loadImage() async {
    //current user id
    final _userID = FirebaseAuth.instance.currentUser!.uid;

    //collect the image name
    DocumentSnapshot variable = await FirebaseFirestore.instance.collection('data_user').doc('user').collection('personal_data').doc(_userID).get();

    //a list of images names (i need only one)
    var _file_name = variable['path_profile_image'];

    //select the image url
    Reference ref = FirebaseStorage.instance.ref().child("images_1.jpeg");

    //get image url from firebase storage
    var url = await ref.getDownloadURL();
    print('url: ' + url);
    return url;
  }
}
