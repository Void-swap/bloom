import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ApplicationPage extends StatefulWidget {
  final String jobId;

  ApplicationPage({required this.jobId});

  @override
  _ApplicationPageState createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  String? message;
  String? filePath;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        filePath = result.files.single.path; // Store the file path
      });
    }
  }

  Future<void> applyForJob(
      String jobId, String userId, String message, String? filePath) async {
    // Validate jobId
    if (jobId.isEmpty) {
      throw Exception("Job ID must not be empty");
    }

    // Create the application data structure
    final application = {
      'userId': userId,
      'message': message,
      'filePath': filePath,
      'appliedOn': Timestamp.now(),
      'status': "pending"
    };

    // Update the job document by adding the application to an array
    await FirebaseFirestore.instance.collection('careers').doc(jobId).update({
      'applications': FieldValue.arrayUnion([application]),
    });
  }

  Future<void> _applyForJob() async {
    if (_formKey.currentState!.validate()) {
      if (message == null || message!.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please enter a message")));
        return;
      }
      try {
        print("Applying for job with ID: ${widget.jobId}");
        await applyForJob(widget.jobId, "userId", message!,
            filePath); // Replace "userId" with actual user ID
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Application submitted!")));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Apply for Job")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: widget.jobId),
                  onChanged: (value) => message = value,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter a message" : null,
                ),
                SizedBox(height: 20),
                Text(filePath != null
                    ? "Selected File: $filePath"
                    : "No file selected"),
                TextButton(
                  onPressed: _pickFile,
                  child: Text("Choose File"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _applyForJob,
                  child: Text("Submit Application"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
