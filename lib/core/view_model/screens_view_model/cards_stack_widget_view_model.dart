import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tinder_app_new/core/view_model/base_model.dart';

class CardsStackWidgetViewModel extends BaseModel {
  String userToken = '';
  String userName = '';
  String image = '';

  addLike(String id, String userId) async {
    FirebaseFirestore.instance.collection("Users").doc(userId).update({
      "like_list": FieldValue.arrayUnion([
        {'id': id, 'status': "send"}
      ]),
    });
  }
}
