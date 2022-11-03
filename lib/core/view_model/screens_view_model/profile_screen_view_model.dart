import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_app_new/core/view_model/base_model.dart';

class ProfileScreenViewModel extends BaseModel {
  String? name;
  String? email;
  String? image;
  String? gender;

  getDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name');
    email = prefs.getString('email');
    image = prefs.getString('image');
    gender = prefs.getString('gender');
    updateUI();
  }
}
