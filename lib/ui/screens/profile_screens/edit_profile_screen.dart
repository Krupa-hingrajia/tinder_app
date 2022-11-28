import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/constant/image_constant.dart';
import 'package:tinder_app_new/core/model/edit_model.dart';
import 'package:tinder_app_new/core/routing/routes.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/profile_screen_view_models/edit_profile_screen_view_model.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatefulWidget {
  EditArguments? editArguments;

  EditProfileScreen({Key? key, this.editArguments}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  EditProfileScreenViewModel? model;
  final firebaseStorage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefValue) => {
          setState(() {
            model!.id = prefValue.getString('id');
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<EditProfileScreenViewModel>(builder: (buildContext, model, child) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                  onTap: () {
                    model.circular = true;
                    model.updateImage(model.id.toString());
                    model.setDataForProfile();
                    Navigator.pushNamedAndRemoveUntil(context, Routes.allScreenBottom, (route) => false);
                    setState(() {});
                  },
                  child: model.circular == true
                      ? const SizedBox(height: 17, width: 21, child: CircularProgressIndicator(color: Colors.blue))
                      : Image.asset(ImageConstant.check)),
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
                  model.imageFile == null
                      ? ClipOval(
                          child: CachedNetworkImage(
                            height: MediaQuery.of(context).size.height * 0.16,
                            width: MediaQuery.of(context).size.width * 0.32,
                            fit: BoxFit.cover,
                            imageUrl: widget.editArguments!.imageUrl.toString(),
                            placeholder: (context, url) => const CircularProgressIndicator(color: Colors.blue),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(model.imageFile!),
                          backgroundColor: Colors.white,
                          maxRadius: MediaQuery.of(context).size.height * 0.08,
                          minRadius: MediaQuery.of(context).size.width * 0.08,
                        )
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
              TextFormField(controller: model.nameController),
              const SizedBox(height: 20),
              const Text('Email'),
              TextFormField(controller: model.emailController)
            ],
          ),
        ),
      );
    }, onModelReady: (model) {
      this.model = model;
      model.circular = false;
      model.getUserDetail(widget.editArguments!.id.toString());
      model.nameController.text = widget.editArguments!.name.toString();
      model.emailController.text = widget.editArguments!.email.toString();
      print('NAME  :: ${model.nameController.text}');
      print('EMAIL  :: ${model.emailController.text}');
    });
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
    final XFile? pickImage = await model!.imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 10);
    model!.imageFile = (File(pickImage!.path));

    String fileName = model!.imageFile!.path.split('image_picker')[1];
    print('image Url $fileName');

    var snapshot = await firebaseStorage.ref().child('images/$fileName').putFile(model!.imageFile!);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      model!.imageUrl = downloadUrl;
      print('image Url ${model!.imageUrl}');
    });
  }

  /// Get from Camera.
  _getFromCamera() async {
    final XFile? pickImage = await model!.imagePicker.pickImage(source: ImageSource.camera, imageQuality: 10);
    model!.imageFile = (File(pickImage!.path));
    String fileName = model!.imageFile!.path.split('image_picker')[1];
    print('image Url $fileName');

    var snapshot = await firebaseStorage.ref().child('images/$fileName').putFile(model!.imageFile!);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      model!.imageUrl = downloadUrl;
      print('image Url ${model!.imageUrl}');
    });
  }
}
