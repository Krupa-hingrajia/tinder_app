import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/constant/image_constant.dart';
import 'package:tinder_app_new/core/constant/text_style_constant.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/ui/widget/custom_btn.dart';
import 'package:tinder_app_new/ui/widget/custom_text_field.dart';

import '../../core/view_model/screens_view_model/login_screen_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginScreenViewModel? model;

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginScreenViewModel>(
      builder: (buildContext, model, child) {
        return Scaffold(
          body: Form(
            key: model.formKey,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.pinkAccent.shade400],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: const [0.2, 0.7],
                  tileMode: TileMode.repeated,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(ImageConstant.splashLogo),
                  customTextField(
                      controller: model.emailController,
                      text: "Email",
                      validator: (value) {
                        String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                        RegExp regex = RegExp(pattern);
                        return value == null || value.isEmpty || !regex.hasMatch(value)
                            ? 'Enter valid email address'
                            : null;
                      }),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                  customTextField(
                    obscureText: model.obscureTextPwd,
                    suffixIcon: GestureDetector(
                        onTap: () {
                          model.obscureTextPwd = !model.obscureTextPwd;
                          model.updateUI();
                        },
                        child: Icon(
                          model.obscureTextPwd == true ? Icons.visibility : Icons.visibility_off_rounded,
                          color: Colors.white,
                        )),
                    controller: model.nameController,
                    text: 'Password',
                    validator: (value) {
                      RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      return !regex.hasMatch(value!) || value.isEmpty ? 'Enter valid password' : null;
                    },
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Padding(
                        padding: const EdgeInsets.only(right: 20, top: 10, bottom: 15),
                        child: GestureDetector(
                            onTap: () {
                              ///// SIGN UP SCREEN.
                            },
                            child: const Text(
                              'Sign Up?',
                              style: TextStyleConstant.sigUpStyle,
                            )))
                  ]),
                  customButton(
                    height: MediaQuery.of(context).size.height * 0.052,
                    width: MediaQuery.of(context).size.width * 0.4,
                    onPressed: () {
                      if (model.formKey.currentState!.validate()) {
                        model.updateUI();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
      onModelReady: (model) {
        this.model = model;
      },
    );
  }
}
