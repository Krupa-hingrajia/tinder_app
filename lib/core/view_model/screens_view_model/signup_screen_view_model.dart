import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_app_new/core/routing/routes.dart';
import 'package:tinder_app_new/core/view_model/base_model.dart';
import 'package:tinder_app_new/ui/widget/costom_snk.dart';

class SignUpScreenViewModel extends BaseModel {
  var token;
  final firebaseMessaging = FirebaseMessaging.instance;
  FirebaseFirestore tinderUsers = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  bool signupCircular = false;
  String? imageUrl;
  String? documentId;
  bool imageError = false;
  bool selectGender = false;

  String dropDnwName = 'Gender';
  String? selectedValue;
  List<String> dropDnwList = ["Male", "Female", "Other"];

  bool obscureTextPwd = true;
  bool obscureTextConPwd = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  setDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', nameController.text);
    prefs.setString('email', emailController.text);
    prefs.setString('image', imageUrl.toString());
    prefs.setString('gender', selectedValue.toString());
    updateUI();
  }

  createUser({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('seen', true);
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(context, Routes.allScreenBottom, (route) => false);
    } on FirebaseAuthException catch (e) {
      signupCircular = false;
      if (e.code == 'weak-password') {
        coustomSnk(context: context, text: "The password provided is too weak.");
        updateUI();
      } else if (e.code == 'email-already-in-use') {
        coustomSnk(context: context, text: "The account already exists for that email.");
        updateUI();
      }
    }
  }

  addTinderUser() async {
    await firebaseMessaging.getToken().then((value) {
      token = value;
    });
    print("******** TOKEN *******: $token");
    String id = tinderUsers.collection("Users").doc().id;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', id);
    return tinderUsers
        .collection("Users")
        .doc(id)
        .set({
          'name': nameController.text,
          'email': emailController.text,
          'gender': selectedValue.toString(),
          'image_url': imageUrl,
          'isFavourite': false,
          'useToken': token,
          'id': id,
        })
        .then((value) => print("User data Added"))
        .catchError((error) => print("User couldn't be added."));
  }
}
