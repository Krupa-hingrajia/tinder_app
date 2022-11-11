import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/constant/image_constant.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/profile_screen_view_models/edit_profile_screen_view_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  EditProfileScreenViewModel? model;
  final ImagePicker imagePicker = ImagePicker();
  File? imageFile;
  final firebaseStorage = FirebaseStorage.instance;
  String? image;
  String? name;
  TextEditingController nameController = TextEditingController();
  String? email;
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefValue) => {
          setState(() {
            image = prefValue.getString('image');
            name = prefValue.getString('name');
            email = prefValue.getString('email');
            nameController = TextEditingController(text: name);
            emailController = TextEditingController(text: email);
            print('IMAGEEEEEEE :: $image');
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<EditProfileScreenViewModel>(
      builder: (buildContext, model, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(ImageConstant.check),
              )
            ],
            flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
              colors: <Color>[ColorConstant.yellowLight, ColorConstant.greenLight],
            ))),
            title: const Text('Edit profile'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(19.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(image ?? ''),
                      backgroundColor: Colors.white,
                      maxRadius: MediaQuery.of(context).size.height * 0.08,
                      minRadius: MediaQuery.of(context).size.width * 0.08,
                    ),
                  ],
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 22.0),
                    child: GestureDetector(
                        onTap: () {
                          _showActionSheet(context);
                          setState(() {});
                        },
                        child: const Text('Change profile photo', style: TextStyle(color: Colors.blue, fontSize: 17))),
                  ),
                ),
                const Text('Name'),
                TextFormField(controller: nameController),
                const SizedBox(height: 20),
                const Text('Email'),
                TextFormField(controller: emailController)
              ],
            ),
          ),
        );
      },
      onModelReady: (model) {
        this.model = model;
      },
    );
  }

  /// Bottom Sheet.
  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                onPressed: () {
                  _getFromCamera();
                  Navigator.pop(context);
                },
                child: const Text('Upload from camera', style: TextStyle(color: Colors.blue)),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  _getFromGallery();
                  Navigator.pop(context);
                },
                child: const Text('Upload from gallery', style: TextStyle(color: Colors.blue)),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel',
                    style: TextStyle(color: Colors.red, letterSpacing: 1.2, fontWeight: FontWeight.w500)),
              ),
            ]));
  }

  /// Get from gallery.
  _getFromGallery() async {
    final XFile? pickImage = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 10);
    imageFile = (File(pickImage!.path));

    String fileName = imageFile!.path.split('image_picker')[1];
    print('image Url $fileName');

    var snapshot = await firebaseStorage.ref().child('images/$fileName').putFile(imageFile!);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      model!.imageUrl = downloadUrl;
      print('image Url ${model!.imageUrl}');
    });
  }

  /// Get from Camera.
  _getFromCamera() async {
    final XFile? pickImage = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 10);
    imageFile = (File(pickImage!.path));
    String fileName = imageFile!.path.split('image_picker')[1];
    print('image Url $fileName');

    var snapshot = await firebaseStorage.ref().child('images/$fileName').putFile(imageFile!);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      model!.imageUrl = downloadUrl;
      print('image Url ${model!.imageUrl}');
    });
  }
}
