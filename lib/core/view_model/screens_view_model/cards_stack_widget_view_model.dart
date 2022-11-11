import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_app_new/core/view_model/base_model.dart';

class CardsStackWidgetViewModel extends BaseModel {
  String? genderGet;
  String? gender;
  String? id;

  getDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    genderGet = prefs.getString('gender');
    print('GENDER :- $genderGet');
    updateUI();
  }


/*  getUserGender() async {
    // gender = '';
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Users').where('gender', isEqualTo: genderGet).get();

    for (var doc in querySnapshot.docs) {
      gender = doc.get('gender');
      id = doc.get('id');
      print('GENDERRRR :: $gender');
      print('IDDDDDDDD :: $id');
    }
  }*/
}
