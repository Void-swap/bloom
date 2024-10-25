class VenueModel {
  String UID;
  String name;
  String address;
  String city;
  String owner;
  String description;
  int capacity;
  List<String> facilities;
  String contactPerson;
  String contactEmail;
  String contactPhone;
  List<String> images;
  List<Map<String, dynamic>> reviews;
  String accessibilityInfo;
  List<String> tags;
  List<String> Availibility; // New field for available days
  bool isAvailableAllTime; // Indicates if the venue is available at all times

  VenueModel({
    required this.UID,
    required this.name,
    required this.address,
    required this.city,
    required this.owner,
    required this.description,
    required this.capacity,
    required this.facilities,
    required this.contactPerson,
    required this.contactEmail,
    required this.contactPhone,
    required this.images,
    required this.reviews,
    required this.accessibilityInfo,
    required this.tags,
    required this.Availibility, // Initialize new field
    required this.isAvailableAllTime, // Initialize new field
  });

  Map<String, dynamic> toMap() {
    return {
      'UID': UID,
      'name': name,
      'address': address,
      'city': city,
      'owner': owner,
      'description': description,
      'capacity': capacity,
      'facilities': facilities,
      'contactPerson': contactPerson,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'images': images,
      'reviews': reviews,
      'accessibilityInfo': accessibilityInfo,
      'tags': tags,
      'Availibility': Availibility, // Add to map
      'isAvailableAllTime': isAvailableAllTime, // Add to map
    };
  }

  factory VenueModel.fromMap(Map<String, dynamic> map) {
    return VenueModel(
      UID: map['UID'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      owner: map['owner'] ?? '',
      description: map['description'] ?? '',
      capacity: map['capacity'] ?? 0,
      facilities: List<String>.from(map['facilities'] ?? []),
      contactPerson: map['contactPerson'] ?? '',
      contactEmail: map['contactEmail'] ?? '',
      contactPhone: map['contactPhone'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      reviews: List<Map<String, dynamic>>.from(map['reviews'] ?? []),
      accessibilityInfo: map['accessibilityInfo'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      Availibility:
          List<String>.from(map['Availibility'] ?? []), // Initialize new field
      isAvailableAllTime:
          map['isAvailableAllTime'] ?? false, // Initialize new field
    );
  }
}
