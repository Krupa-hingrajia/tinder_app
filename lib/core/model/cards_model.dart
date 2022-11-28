class ProfilePicture {
  final String? imageURL;
  final String? userName;
  final String? gender;
  final String? id;
 final  List<dynamic>? isFavourite;

  ProfilePicture(this.imageURL, this.userName, this.gender, this.id, this.isFavourite);
}

class ChatRoomId {
  final String? senderId;
  final String? receiverId;

  ChatRoomId(this.senderId, this.receiverId);
}


class StatusConfirmList{
  final String? id;
  final String? status;

  StatusConfirmList({this.id, this.status});
}
