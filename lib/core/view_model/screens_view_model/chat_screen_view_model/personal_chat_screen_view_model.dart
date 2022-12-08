import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tinder_app_new/core/view_model/base_model.dart';

class PersonalChatScreenViewModel extends BaseModel {
  bool send = false;
  TextEditingController sendController = TextEditingController();

  showToast(String text) {
    return Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        backgroundColor: Colors.grey.shade500,
        fontSize: 14.0);
  }
}
