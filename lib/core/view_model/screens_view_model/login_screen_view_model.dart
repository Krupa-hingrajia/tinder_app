import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/model/cards_model.dart';
import 'package:tinder_app_new/core/model/profile_model.dart';
import 'package:tinder_app_new/core/routing/routes.dart';
import 'package:tinder_app_new/core/view_model/base_model.dart';
import 'package:tinder_app_new/ui/widget/costom_snk.dart';

class LoginScreenViewModel extends BaseModel {
  final formKey = GlobalKey<FormState>();
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  List<ProfilePicture> list = [];
  String? name;
  String? email;
  String? gender;
  String? imageURL;
  bool loginCircular = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureTextPwd = true;

  getUserDetail() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Users').where('email', isEqualTo: emailController.text).get();

    for (var doc in querySnapshot.docs) {
      name = doc.get('name');
      email = doc.get('email');
      gender = doc.get('gender');
      imageURL = doc.get('image_url');
      print('NAME :: $name');
      print('EMAIL :: $email');
      print('GENDER :: $gender');
      print('IMAGE-URL  :: $imageURL');
    }
  }

  signInUser({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(context, Routes.settingScreen, (route) => false,
          arguments: UserArguments(name: name, gender: gender, email: email, imageURL: imageURL));
    } on FirebaseAuthException catch (e) {
      loginCircular = false;
      if (e.code == 'wrong-password') {
        coustomSnk(context: context, text: "Wrong password provided for that user.");
        updateUI();
      } else if (e.code == 'user-not-found') {
        coustomSnk(context: context, text: "No user found for that email.");
        updateUI();
      }
    }
  }
}
