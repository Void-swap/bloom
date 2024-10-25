class EventModel {
  String UID;
  String organizer;
  String name;
  String description;
  String date;
  String time;
  String venue;
  String city;
  List<Map<String, dynamic>> reviews;
  String status;
  List<String> tags;
  List<Map<String, String>> volunteers;
  List<Map<String, String>> attendees;
  String contact;
  String accessibilityInfo;
  String specialInstruction;
  String type;
  List<String> images;

  EventModel({
    required this.UID,
    required this.organizer,
    required this.name,
    required this.description,
    required this.date,
    required this.time,
    required this.venue,
    required this.city,
    required this.reviews,
    required this.status,
    required this.tags,
    required this.volunteers,
    required this.attendees,
    required this.contact,
    required this.accessibilityInfo,
    required this.specialInstruction,
    required this.type,
    required this.images,
  });

  Map<String, dynamic> toMap() {
    return {
      'UID': UID,
      'organizer': organizer,
      'name': name,
      'description': description,
      'date': date,
      'time': time,
      'venue': venue,
      'city': city,
      'reviews': reviews,
      'status': status,
      'tags': tags,
      'volunteers': volunteers,
      'attendees': attendees,
      'contact': contact,
      'accessibilityInfo': accessibilityInfo,
      'specialInstruction': specialInstruction,
      'type': type,
      'images': images,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      UID: map['UID'] ?? '',
      organizer: map['organizer'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      venue: map['venue'] ?? '',
      city: map['city'] ?? '',
      reviews: List<Map<String, dynamic>>.from(map['reviews'] ?? []),
      status: map['status'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      volunteers: List<Map<String, String>>.from(map['volunteers'] ?? []),
      attendees: List<Map<String, String>>.from(map['attendees'] ?? []),
      contact: map['contact'] ?? '',
      accessibilityInfo: map['accessibilityInfo'] ?? '',
      specialInstruction: map['specialInstruction'] ?? '',
      type: map['type'] ?? '',
      images: List<String>.from(map['images'] ?? []),
    );
  }
}
