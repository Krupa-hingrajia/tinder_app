import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

String? userToken;

Future<void> sendPushMessage(String? userId, String name, String body, {String? docId, String? collectionId}) async {
  final querySnapshot = await FirebaseFirestore.instance.collection('Users').where('id', isEqualTo: userId).get();

  for (var element in querySnapshot.docs) {
    userToken = element.get('useToken');
    print('TOOOOOOOOOO  :- $userToken');
  }

  try {
    var headers = {
      'Authorization':
          'key=AAAA0FDqNaQ:APA91bEaEPf-lW6D4W3pXPyaI1QJKWHhYUrCHK0riCvOPvVN_LTmrrEjcLNUtHbWVuRfdBeRksSh8mY8Bxzr3IEBKLx6TovbQQzEnJG6tNKf6JjmAl10sLuW64u1C2dgPNiXa3i6Re9I',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "to": userToken,
      "notification": {"title": name, "body": body},
      "data": {"docId": docId, "collectionId": collectionId},
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  } catch (e) {
    print(e);
  }
}
