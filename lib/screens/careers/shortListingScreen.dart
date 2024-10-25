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
          // Filter for pending applicants
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
      // Update the applicant's status in the existing applications array
      final jobDocRef =
          FirebaseFirestore.instance.collection('careers').doc(widget.jobId);

      // Use a transaction to ensure atomicity
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot jobSnapshot = await transaction.get(jobDocRef);
        if (jobSnapshot.exists) {
          List<dynamic> applications = jobSnapshot['applications'];

          // Update the specific applicant's status
          for (var app in applications) {
            if (app['userId'] == applicantId) {
              app['status'] = status; // Update the status
              break;
            }
          }

          // Update the job document with the modified applications list
          transaction.update(jobDocRef, {'applications': applications});
        }
      });

      fetchApplicants(); // Refresh the list
    } catch (e) {
      print("Error updating status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Applicants screen"),
      ),
      body: applicants.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: applicants.length,
              itemBuilder: (context, index) {
                final applicant = applicants[index];
                return ListTile(
                  title: Text(applicant['name'] ?? 'Unknown'),
                  subtitle: Text("Status: ${applicant['status'] ?? 'Unknown'}"),
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
                );
              },
            ),
    );
  }
}
