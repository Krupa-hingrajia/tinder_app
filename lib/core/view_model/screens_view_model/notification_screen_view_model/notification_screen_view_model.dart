import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tinder_app_new/core/view_model/base_model.dart';

class NotificationScreenViewModel extends BaseModel {
  TextEditingController searchController = TextEditingController();
  var collection = FirebaseFirestore.instance.collection('Users');

  deleteNotification(String userId, String id) async {
    collection.doc(userId).update({
      'like_list': FieldValue.arrayRemove([
        {'id': id, 'status': "send"}
      ]),
    });
  }

  confirmNotification(String userId, String id) async {
    collection.doc(userId).update({
      "like_list": FieldValue.arrayUnion([
        {'id': id, 'status': "confirm"}
      ]),
    });
  }
}
