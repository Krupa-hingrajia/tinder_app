import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_app_new/core/view_model/base_model.dart';

class SettingScreenViewModel extends BaseModel {
  String? genderGet;
  String? selectValue;
  List<String> dropDnwList = ["Male", "Female", "All"];

  setDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('gender', selectValue.toString());
    updateUI();
  }

  getDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    genderGet = prefs.getString('gender');
    updateUI();
  }
}
