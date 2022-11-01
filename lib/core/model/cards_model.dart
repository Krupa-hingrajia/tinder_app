// class Cards {
//   String image;
//
//   Cards({required this.image});
// }
//
// List<Cards> cards = [
//   Cards(image: 'assets/image/images_1.jpeg'),
//   Cards(image: 'assets/image/images_2.jpeg'),
//   Cards(image: 'assets/image/images_3.jpeg'),
//   Cards(image: 'assets/image/images_4.jpeg'),
//   Cards(image: 'assets/image/images_5.jpeg'),
//   Cards(image: 'assets/image/images_6.jpeg'),
// ];

class Profile {
  const Profile({
    required this.name,
    required this.distance,
    required this.imageAsset,
  });

  final String name;
  final String distance;
  final String imageAsset;
}

class ProfilePicture {
  final String imageURL;
  final String userName;
  final String gender;
  final String id;
  final bool isFavourite;

  ProfilePicture(this.imageURL, this.userName, this.gender, this.id, this.isFavourite);
}
