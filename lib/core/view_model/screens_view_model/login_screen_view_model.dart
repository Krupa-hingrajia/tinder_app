import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/routing/routes.dart';
import 'package:tinder_app_new/core/view_model/base_model.dart';
import 'package:tinder_app_new/ui/widget/costom_snk.dart';

class LoginScreenViewModel extends BaseModel {
  final formKey = GlobalKey<FormState>();
  bool loginCircular = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureTextPwd = true;

  signInUser({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(context, Routes.homeScreen, (route) => false);
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
