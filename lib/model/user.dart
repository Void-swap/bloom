class UserModel {
  String uid;
  String description;
  String profilePic;
  String name;
  String address;
  String contacts;
  String email;
  String isVerified;
  String socialMediaLinks;
  List<String> interests;
  String role;
  List<String> attendedEvents;
  List<String> badges;
  String foundedOn;
  List<String> listingCreated;
  List<String> venuesCreated;
  UserModel({
    required this.uid,
    required this.description,
    required this.profilePic,
    required this.name,
    required this.address,
    required this.contacts,
    required this.email,
    required this.isVerified,
    required this.socialMediaLinks,
    required this.interests,
    required this.role,
    required this.attendedEvents,
    required this.badges,
    required this.foundedOn,
    this.listingCreated = const [],
    this.venuesCreated = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'profilePic': profilePic,
      'description': description,
      'name': name,
      'address': address,
      'contacts': contacts,
      'email': email,
      'isVerified': isVerified,
      'socialMediaLinks': socialMediaLinks,
      'interests': interests,
      'role': role,
      'attendedEvents': attendedEvents,
      'badges': badges,
      'foundedOn': foundedOn,
      'listingCreated': listingCreated,
      'venuesCreated': venuesCreated,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      description: map['description'] ?? '',
      profilePic: map['profilePic'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      contacts: map['contacts'] ?? '',
      email: map['email'] ?? '',
      isVerified: map['isVerified'] ?? "Not Applied",
      socialMediaLinks: map['socialMediaLinks'] ?? '',
      interests: List<String>.from(map['interests'] ?? []),
      role: map['role'] ?? '',
      attendedEvents: List<String>.from(map['attendedEvents'] ?? []),
      badges: List<String>.from(map['badges'] ?? []),
      foundedOn: map['foundedOn'] ?? '',
      listingCreated: List<String>.from(map['listingCreated'] ?? []),
      venuesCreated: List<String>.from(map['venuesCreated'] ?? []),
    );
  }
}
