// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:url_launcher/url_launcher.dart';

// class VerificationDetailScreen extends StatelessWidget {
//   final String verificationId; // ID of the verification request

//   VerificationDetailScreen({required this.verificationId});

//   Future<Map<String, dynamic>?> _fetchVerificationDetails() async {
//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection('verification')
//           .doc(verificationId)
//           .get();

//       if (doc.exists) {
//         return doc.data();
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print('Error fetching verification details: $e');
//       return null;
//     }
//   }

//   Future<void> _launchURL(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   Future<void> _handleVerify() async {
//     try {
//       final firestore = FirebaseFirestore.instance;
//       await firestore.collection('verification').doc(verificationId).update({
//         'status': 'Verified',
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('User Verified')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error verifying user: $e')),
//       );
//     }
//   }

//   Future<void> _handleReject() async {
//     try {
//       final firestore = FirebaseFirestore.instance;
//       await firestore.collection('verification').doc(verificationId).update({
//         'status': 'Rejected',
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('User Rejected')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error rejecting user: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Verification Details'),
//       ),
//       body: FutureBuilder<Map<String, dynamic>?>(
//         future: _fetchVerificationDetails(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           final data = snapshot.data;

//           if (data == null) {
//             return Center(child: Text('No details found'));
//           }

//           final cvUrl = data['cvUrl'] as String? ?? '';
//           final motivation = data['motivation'] as String? ?? '';
//           final pastExperience = data['pastExperience'] as String? ?? '';

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Motivation:',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Text(motivation),
//                 SizedBox(height: 16),
//                 Text(
//                   'Past Experience:',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Text(pastExperience),
//                 SizedBox(height: 16),
//                 Text(
//                   'CV:',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 cvUrl.isNotEmpty
//                     ? InkWell(
//                         onTap: () => _launchURL(cvUrl),
//                         child: Text(
//                           'View CV',
//                           style: TextStyle(color: Colors.primaryBlack, fontSize: 16),
//                         ),
//                       )
//                     : Text('No CV available'),
//                 SizedBox(height: 32),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       onPressed: _handleVerify,
//                       child: Text('Verify'),
//                     ),
//                     ElevatedButton(
//                       onPressed: _handleReject,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red, // Background color for Reject
//                       ),
//                       child: Text('Reject'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
