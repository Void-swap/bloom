import 'package:cloud_firestore/cloud_firestore.dart';

class JobsModel {
  String uid; // Unique job ID
  String type; // Job type (e.g., "Full-time", "Part-time", "Internship")
  String listedBy; // User or organization listing the job
  String responsibility; // Job description or key responsibilities
  String duration; // Job duration (e.g., "6 months", "1 year")
  String workMode; // Work mode (e.g., "Remote", "On-site", "Hybrid")
  String location; // Job location (if on-site or hybrid)
  DateTime startDate; // Start date of the job
  double pay; // Salary or hourly pay
  String fullOrPart; // Full-time or Part-time
  int numberOfOpenings; // Number of openings for the job
  List<String> perks; // List of perks offered
  List<String> skills; // Required skills for the job
  DateTime createdOn; // Timestamp for job creation
  String position; // Job position title
  String pfpImageURL; // Profile image URL
  String name; // Company name

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
