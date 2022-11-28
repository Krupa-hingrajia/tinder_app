import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_app_new/core/view_model/base_model.dart';

class SettingScreenViewModel extends BaseModel {
  String? genderGet;
  String? loginId;
  bool showTinder = true;
  RangeValues ageRange = const RangeValues(0, 100);
  RangeValues? ageRangeGet;
  String? ageValue;
  String? ageValueGet;
  String? selectValue;
  List<String> dropDnwList = ["Male", "Female", "All"];
  FirebaseFirestore firebase = FirebaseFirestore.instance;

  setDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('gender', selectValue.toString());
    updateUI();
  }

  getDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    genderGet = prefs.getString('gender');
    ageValueGet = prefs.getString('ageRange');
    loginId = prefs.getString('id');

    List<String> valuesString = [ageRange.start.round().toString(), ageRange.end.round().toString()];
    valuesString = (prefs.getStringList('sliderGain') ?? [valuesString.toString()]);
    // print('valuesString  :-- $valuesString');
    // print('AGE RANGE  :-- $ageValueGet');
    // print('AGE RANGE GET :-- $ageRange');
    print('IDDD :- $loginId');
    updateUI();
  }

  showMeOnTinder(String userId) async {
    await firebase.collection('Users').doc(userId).update({'showMeOnTinder': false});
  }

}
