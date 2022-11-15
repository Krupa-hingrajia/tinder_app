import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_app_new/core/view_model/base_model.dart';

class EditProfileScreenViewModel extends BaseModel {
  String? id;
  File? imageFile;
  String? imageUrl;
  final ImagePicker imagePicker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  getUserDetail(String id) async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Users').where('id', isEqualTo: id.toString()).get();

    for (var doc in querySnapshot.docs) {
      imageUrl = doc.get('image_url');
      print('IMAGE  :: $imageUrl');
    }
  }

  updateImage(String id) {
    var collection = FirebaseFirestore.instance.collection('Users');
    collection
        .doc(id)
        .update({'name': nameController.text, 'image_url': imageUrl})
        .then((_) => print('Success'))
        .catchError((error) => print('Failed: $error'));
    updateUI();
  }

  setDataForProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text);
    await prefs.setString('image', imageUrl.toString());
    updateUI();
  }
}
