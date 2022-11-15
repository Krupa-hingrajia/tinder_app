import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinder_app_new/core/constant/image_constant.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/ui/widget/custom_btn.dart';
import 'package:tinder_app_new/ui/widget/custom_drop_down.dart';
import 'package:tinder_app_new/ui/widget/custom_text_field.dart';

import '../../core/constant/color_constant.dart';
import '../../core/view_model/screens_view_model/signup_screen_view_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpScreenViewModel? model;
  final ImagePicker imagePicker = ImagePicker();
  File? imageFile;
  final firebaseStorage = FirebaseStorage.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    model!.nameController.clear();
    model!.emailController.clear();
    model!.passwordController.clear();
    model!.confirmPassController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<SignUpScreenViewModel>(builder: (buildContext, model, child) {
      return Scaffold(
        body: Form(
          key: model.formKey,
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [ColorConstant.yellowLight, ColorConstant.greenLight],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: [0.2, 0.7],
                tileMode: TileMode.repeated,
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Image.asset(ImageConstant.splashLogo, color: ColorConstant.black),
                  GestureDetector(
                      onTap: () {
                        _showActionSheet(context);
                        setState(() {});
                      },
                      child: imageFile == null
                          ? Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.36,
                                  height: MediaQuery.of(context).size.width * 0.36,
                                  decoration: const BoxDecoration(
                                      color: ColorConstant.white,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(image: AssetImage(ImageConstant.user), fit: BoxFit.cover)),
                                ),
                                Positioned(
                                    right: MediaQuery.of(context).size.shortestSide * 0,
                                    height: MediaQuery.of(context).size.height * 0.044,
                                    bottom: MediaQuery.of(context).size.height * 0.013,
                                    child: Container()),
                              ],
                            )
                          : Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.36,
                                  height: MediaQuery.of(context).size.width * 0.36,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(image: FileImage(imageFile!), fit: BoxFit.cover),
                                  ),
                                ),
                              ],
                            )),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.014),
                  model.imageError == true
                      ? const Text('Please upload image', style: TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 1.1))
                      : Container(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  customTextField(
                    controller: model.nameController,
                    text: 'Name',
                    validator: (value) {
                      return value!.isEmpty ? 'Enter name' : null;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  customTextField(
                      controller: model.emailController,
                      text: "Email",
                      validator: (value) {
                        String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                        RegExp regex = RegExp(pattern);
                        return value == null || value.isEmpty || !regex.hasMatch(value) ? 'Enter valid email address' : null;
                      }),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  customTextField(
                    obscureText: model.obscureTextPwd,
                    suffixIcon: GestureDetector(
                        onTap: () {
                          model.obscureTextPwd = !model.obscureTextPwd;
                          model.updateUI();
                        },
                        child: Icon(
                          model.obscureTextPwd ? Icons.visibility : Icons.visibility_off_rounded,
                          color: ColorConstant.black,
                        )),
                    controller: model.passwordController,
                    text: 'Password',
                    validator: (value) {
                      RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      return !regex.hasMatch(value!) || value.isEmpty ? 'Enter valid password' : null;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  customTextField(
                    obscureText: model.obscureTextConPwd,
                    suffixIcon: GestureDetector(
                        onTap: () {
                          model.obscureTextConPwd = !model.obscureTextConPwd;
                          model.updateUI();
                        },
                        child: Icon(
                          model.obscureTextConPwd ? Icons.visibility : Icons.visibility_off_rounded,
                          color: ColorConstant.black,
                        )),
                    controller: model.confirmPassController,
                    text: 'Confirm Password',
                    validator: (value) {
                      return model.passwordController.text != model.confirmPassController.text ? "password don't match" : null;
                    },
                  ),
                  dropDownWidget(
                    context: context,
                    height: MediaQuery.of(context).size.height * 0.062,
                    categoryList: model.dropDnwList,
                    hintText: model.dropDnwName,
                    dropDownValue: model.selectedValue,
                    onChanged: (value) {
                      model.selectedValue = value;
                      setState(() {});
                    },
                  ),
                  model.selectGender == true
                      ? const Padding(
                          padding: EdgeInsets.only(top: 8.0, left: 34),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text('Please select your gender', style: TextStyle(color: Colors.white, fontSize: 16))),
                        )
                      : Container(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  customButton(
                      text: 'Create account',
                      circular: model.signupCircular,
                      height: MediaQuery.of(context).size.height * 0.052,
                      width: MediaQuery.of(context).size.width * 0.45,
                      onPressed: () async {
                        if (model.formKey.currentState!.validate()) {
                          if (imageFile == null) {
                            model.imageError = true;
                            setState(() {});
                          } else if (model.selectedValue == null) {
                            model.selectGender = true;
                            setState(() {});
                          } else {
                            model.createUser(context: context);
                            model.addTinderUser();
                            model.setDate();
                            model.imageError == true || model.selectGender == true ? model.signupCircular = true : model.signupCircular = false;
                            setState(() {});
                          }
                          /*model.signupCircular = true;
                          setState(() {});*/
                        }
                      }),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.036),
                ],
              ),
            ),
          ),
        ),
      );
    }, onModelReady: (model) {
      this.model = model;
    });
  }

  /// Bottom Sheet
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
                child: const Text('Cancel', style: TextStyle(color: Colors.red, letterSpacing: 1.2, fontWeight: FontWeight.w500)),
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
