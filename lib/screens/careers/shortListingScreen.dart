import 'package:bloom/screens/profile/othersProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ApplicantManagementScreen extends StatefulWidget {
  final String jobId;

  ApplicantManagementScreen({required this.jobId});

  @override
  _ApplicantManagementScreenState createState() =>
      _ApplicantManagementScreenState();
}

class _ApplicantManagementScreenState extends State<ApplicantManagementScreen> {
  List<Map<String, dynamic>> applicants = [];

  @override
  void initState() {
    super.initState();
    fetchApplicants();
  }

  Future<void> fetchApplicants() async {
    try {
      DocumentSnapshot jobSnapshot = await FirebaseFirestore.instance
          .collection('careers')
          .doc(widget.jobId)
          .get();

      if (jobSnapshot.exists && jobSnapshot.data() != null) {
        final jobData = jobSnapshot.data() as Map<String, dynamic>;
        final applications = jobData['applications'] as List<dynamic>?;

        if (applications != null) {
          applicants = applications
              .map((app) => app as Map<String, dynamic>)
              .where((app) => app['status'] == 'pending')
              .toList();
          setState(() {});
        }
      }
    } catch (e) {
      print("Error fetching applicants: $e");
    }
  }

  Future<void> updateApplicationStatus(
      String applicantId, String status) async {
    try {
      final jobDocRef =
          FirebaseFirestore.instance.collection('careers').doc(widget.jobId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot jobSnapshot = await transaction.get(jobDocRef);
        if (jobSnapshot.exists) {
          List<dynamic> applications = jobSnapshot['applications'];

          for (var app in applications) {
            if (app['userId'] == applicantId) {
              app['status'] = status;
              break;
            }
          }

          transaction.update(jobDocRef, {'applications': applications});
        }
      });

      fetchApplicants();
    } catch (e) {
      print("Error updating status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Applicants Screen"),
      ),
      body: applicants.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: applicants.length,
              itemBuilder: (context, index) {
                final applicant = applicants[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OthersProfileView(userId: applicant['userId']),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(applicant['name'] ?? 'Unknown'),
                      subtitle:
                          Text("Status: ${applicant['status'] ?? 'Unknown'}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () => updateApplicationStatus(
                                applicant['userId'], 'accepted'),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => updateApplicationStatus(
                                applicant['userId'], 'rejected'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  final String userId;

  UserProfileScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error loading profile"));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("User not found"));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: ${userData['name'] ?? 'Unknown'}",
                    style: TextStyle(fontSize: 24)),
                SizedBox(height: 8),
                Text("Email: ${userData['email'] ?? 'Unknown'}",
                    style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );
  }
}
