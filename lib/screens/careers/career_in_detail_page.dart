import 'package:bloom/form.dart';
import 'package:bloom/model/careers.dart';
import 'package:bloom/screens/careers/application_page.dart';
import 'package:bloom/screens/careers/shortListingScreen.dart';
import 'package:bloom/utils/colors.dart';
import 'package:flutter/material.dart';

class JobDetailScreen extends StatelessWidget {
  final JobsModel job;

  const JobDetailScreen({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job.position), // Title using job position
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ApplicantManagementScreen(
                            jobId: job.uid,
                          )),
                );
              },
              icon: Icon(Icons.abc_outlined))
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Position: ${job.position}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Listed By: ${job.listedBy}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Responsibilities:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(job.responsibility, style: TextStyle(fontSize: 14)),
                  SizedBox(height: 8),
                  Text('Duration: ${job.duration}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Location: ${job.location}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Pay: ${job.pay == 0.0 ? "Unpaid" : "\$${job.pay}"}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Openings: ${job.numberOfOpenings}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Work Mode: ${job.workMode}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Perks:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  for (var perk in job.perks)
                    Text('- $perk', style: TextStyle(fontSize: 14)),
                  SizedBox(height: 8),
                  Text('Skills Required:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  for (var skill in job.skills)
                    Text('- $skill', style: TextStyle(fontSize: 14)),
                  SizedBox(height: 8),
                  Text('Created On: ${job.createdOn.toLocal().toString()}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ApplicationPage(jobId: job.uid)),
                  );
                },
                child: Padding(
                    padding: EdgeInsets.only(bottom: 48),
                    child: CustomButton(name: job.uid, color: orange))),
          )
        ],
      ),
    );
  }
}
