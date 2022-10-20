import 'package:flutter/cupertino.dart';
import 'package:tinder_app_new/core/view_model/base_model.dart';

class LoginScreenViewModel extends BaseModel {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool obscureTextPwd = false;
}
