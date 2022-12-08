import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_app_new/core/routing/routes.dart';
import 'package:tinder_app_new/core/view_model/base_model.dart';
import 'package:tinder_app_new/ui/widget/costom_snk.dart';

class LoginScreenViewModel extends BaseModel {
  final formKey = GlobalKey<FormState>();
  String? id;
  String? name;
  String? email;
  String? imageURL;

  bool loginCircular = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureTextPwd = true;

  getUserDetail() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Users').where('email', isEqualTo: emailController.text).get();

    for (var doc in querySnapshot.docs) {
      id = doc.get('id');
      name = doc.get('name');
      email = doc.get('email');
      imageURL = doc.get('image_url');

      print('ID :: $id');
      print('NAME :: $name');
      print('EMAIL :: $email');
      print('IMAGE-URL  :: $imageURL');
    }

    /// SET DATA FOR PROFILE SCREEN
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', id.toString());
    await prefs.setString('name', name.toString());
    await prefs.setString('email', email.toString());
    await prefs.setString('image', imageURL.toString());
    updateUI();
  }

  updateToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('TOKEEEN   ::::--- $fcmToken');
    await FirebaseFirestore.instance.collection("Users").doc(id).update({
      "useToken": fcmToken,
    });
  }

  signInUser({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('seen', true);
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(context, Routes.allScreenBottom, (route) => false);
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
