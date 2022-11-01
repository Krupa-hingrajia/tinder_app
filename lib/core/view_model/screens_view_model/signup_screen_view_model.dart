import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tinder_app_new/core/routing/routes.dart';
import 'package:tinder_app_new/core/view_model/base_model.dart';
import 'package:tinder_app_new/ui/widget/costom_snk.dart';

class SignUpScreenViewModel extends BaseModel {
  FirebaseFirestore tinderUsers = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  bool signupCircular = false;
  String? imageUrl;
  String? documentId;
  bool imageError = false;
  bool selectGender = false;

  String dropDnwName = 'Gender';
  String? selectValue;
  List<String> dropDnwList = ["Male", "Female", "Other"];

  bool obscureTextPwd = true;
  bool obscureTextConPwd = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  createUser({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(context, Routes.homeScreen, (route) => false);
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

  addTinderUser() {
    String id = tinderUsers.collection("Users").doc().id;
    return tinderUsers
        .collection("Users")
        .doc(id)
        .set({
          'name': nameController.text,
          'email': emailController.text,
          'gender': selectValue.toString(),
          'image_url': imageUrl,
          'isFavourite': false,
          'id': id
        })
        .then((value) => print("User data Added"))
        .catchError((error) => print("User couldn't be added."));
  }
}
