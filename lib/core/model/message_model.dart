class MessageArguments {
  String? title;
  String? image;
  String? id;

  MessageArguments({this.title, this.image, this.id});
}

class PersonalMessageArguments {
  String? title;
  String? profileId;
  String? messageId;
  String? senderId;
  String? receiverId;

  PersonalMessageArguments({this.title, this.profileId, this.senderId, this.receiverId, this.messageId});
}
