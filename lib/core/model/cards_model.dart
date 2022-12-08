import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePicture {
  final String? imageURL;
  final String? userName;
  final String? gender;
  final String? id;
  final List<dynamic>? isFavourite;

  ProfilePicture(this.imageURL, this.userName, this.gender, this.id, this.isFavourite);
}

class ChatRoomId {
  final String? senderId;
  final String? receiverId;
  final String? id;

  ChatRoomId(this.senderId, this.receiverId, this.id);
}

class StatusConfirmList {
  final String? id;
  final String? status;

  StatusConfirmList({this.id, this.status});
}

class MessageList {
  final String? receiverId;
  final String? senderId;
  final String? id;
  Timestamp? time;
  final String? content;

  MessageList(this.receiverId, this.senderId, this.id, this.time, this.content);
}
