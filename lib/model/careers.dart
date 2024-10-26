import 'package:cloud_firestore/cloud_firestore.dart';

class JobsModel {
  String uid;
  String type;
  String listedBy;
  String responsibility;
  String duration;
  String workMode;
  String location;
  DateTime startDate;
  double pay;
  String fullOrPart;
  int numberOfOpenings;
  List<String> perks;
  List<String> skills;
  DateTime createdOn;
  String position;
  String pfpImageURL;
  String name;

  JobsModel({
    required this.uid,
    required this.type,
    required this.listedBy,
    required this.name,
    required this.pfpImageURL,
    required this.responsibility,
    required this.duration,
    required this.workMode,
    required this.location,
    required this.startDate,
    required this.pay,
    required this.fullOrPart,
    required this.numberOfOpenings,
    required this.perks,
    required this.skills,
    required this.createdOn,
    required this.position,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'type': type,
      'listedBy': listedBy,
      'name': name,
      'pfpImageURL': pfpImageURL,
      'responsibility': responsibility,
      'duration': duration,
      'workMode': workMode,
      'location': location,
      'startDate': startDate.toIso8601String(),
      'pay': pay,
      'fullOrPart': fullOrPart,
      'numberOfOpenings': numberOfOpenings,
      'perks': perks,
      'skills': skills,
      'createdOn': createdOn.toIso8601String(),
      'position': position,
    };
  }

  factory JobsModel.fromMap(Map<String, dynamic> map) {
    return JobsModel(
      uid: map['uid'] ?? '',
      type: map['type'] ?? '',
      listedBy: map['listingBy'] ?? '',
      pfpImageURL: map['pfpImageURL'] ?? '',
      name: map['name'] ?? '',
      responsibility: map['responsibility'] ?? '',
      duration: map['duration'] ?? '',
      workMode: map['workMode'] ?? '',
      location: map['location'] ?? '',
      startDate: DateTime.parse(map['startDate']),
      pay: (map['pay'] is String)
          ? double.tryParse(map['pay']) ?? 0.0
          : map['pay'].toDouble(),
      fullOrPart: map['fullOrPart'] ?? '',
      numberOfOpenings: (map['numberOfOpenings'] is String)
          ? int.tryParse(map['numberOfOpenings']) ?? 0
          : map['numberOfOpenings'],
      perks: List<String>.from(map['perks'] ?? []),
      skills: List<String>.from(map['skills'] ?? []),
      createdOn: (map['createdOn'] is Timestamp)
          ? (map['createdOn'] as Timestamp).toDate()
          : DateTime.now(),
      position: map['position'] ?? '',
    );
  }
}
