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
  String foundedOn; // Optional for some roles
  List<String> listingCreated; // Optional for some roles
  List<String> venuesCreated; // Optional for some roles

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

  // Convert a UserModel object to a map to store in Firestore
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

  // Convert a map to a UserModel object to fetch from Firestore
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
