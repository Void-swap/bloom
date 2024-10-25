import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminVerificationScreen extends StatefulWidget {
  @override
  _AdminVerificationScreenState createState() =>
      _AdminVerificationScreenState();
}

class _AdminVerificationScreenState extends State<AdminVerificationScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchVerificationRequests() async {
    try {
      final snapshot = await _firestore
          .collection('verification')
          .where('status', isEqualTo: 'pending')
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching verification requests: $e');
      return [];
    }
  }

  Future<void> _updateVerificationStatus(String uid, String status) async {
    try {
      final usersCollection = _firestore.collection('users');
      final userDoc = usersCollection.doc(uid); // Assuming uid as document ID

      await userDoc.update({
        'isVerified': status,
      });

      final verificationCollection = _firestore.collection('verification');

      // Query for the document with the specified uid
      final querySnapshot =
          await verificationCollection.where('uid', isEqualTo: uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Update the status for each document found
        for (final document in querySnapshot.docs) {
          await document.reference.update({
            'status': status,
          });
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User status updated to $status')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Requests'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchVerificationRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No verification requests found'));
          } else {
            final requests = snapshot.data!;

            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];

                return GestureDetector(
                  onTap: () {},
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('Email: ${request['email']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Motivation: ${request['motivation']}'),
                          const SizedBox(height: 4),
                          Text('Past Experience: ${request['pastExperience']}'),
                          const SizedBox(height: 4),
                          if (request['cvUrl'] != null)
                            Text('CV: ${request['cvFileName']}'),
                        ],
                      ),
                      isThreeLine: true,
                      contentPadding: const EdgeInsets.all(16.0),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () => _updateVerificationStatus(
                                request['uid'], 'Verified'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => _updateVerificationStatus(
                                request['uid'], 'Rejected'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
