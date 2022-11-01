import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/routing/routes.dart';
import 'package:tinder_app_new/ui/widget/custom_btn.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/ui/widget/custom_text_field.dart';
import 'package:tinder_app_new/core/constant/image_constant.dart';
import 'package:tinder_app_new/core/constant/text_style_constant.dart';

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
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [Colors.pinkAccent.shade400, Colors.pinkAccent],
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
                                model.obscureTextPwd ? Icons.visibility : Icons.visibility_off_rounded,
                                color: Colors.white,
                              )),
                          controller: model.passwordController,
                          text: 'Password',
                          validator: (value) {
                            return value!.isEmpty ? 'Enter valid password' : null;
                          },
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          Padding(
                              padding: const EdgeInsets.only(right: 20, top: 10, bottom: 15),
                              child: GestureDetector(
                                  onTap: () async {
                                    ///// SIGN UP SCREEN.
                                    Navigator.pushNamed(context, Routes.signupScreen);

                                    model.emailController.clear();
                                    model.passwordController.clear();
                                    setState(() {});
                                  },
                                  child: const Text('Sign Up?', style: TextStyleConstant.sigUpStyle)))
                        ]),
                        customButton(
                            text: "Login",
                            circular: model.loginCircular,
                            height: MediaQuery.of(context).size.height * 0.052,
                            width: MediaQuery.of(context).size.width * 0.4,
                            onPressed: () async {
                              if (model.formKey.currentState!.validate()) {
                                model.loginCircular = false;
                                setState(() {});
                                model.signInUser(context: context);
                                model.loginCircular = true;
                                setState(() {});
                              }
                            })
                      ],
                    ))));
      },
      onModelReady: (model) async {
        this.model = model;
        // await model.signInUser(context: context);
      },
    );
  }
}
