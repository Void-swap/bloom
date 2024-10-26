import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class AdminVerificationScreen extends StatefulWidget {
  @override
  _AdminVerificationScreenState createState() =>
      _AdminVerificationScreenState();
}

class _AdminVerificationScreenState extends State<AdminVerificationScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<File> getImageFileFromAssets(String imagePath) async {
    final byteData = await rootBundle.load(imagePath);

    final file = File(
        '${(await getTemporaryDirectory()).path}/${path.basename(imagePath)}');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<bool> sendEmail() async {
    String username = 'swapnil.gdsc9@gmail.com';
    String password = 'jgcc huyb fomc tbay';

    final smtpServer = gmail(username, password);
    print("Started to send email");

    File imageFile = await getImageFileFromAssets('assets/images/433.png');
    File Ai = await getImageFileFromAssets('assets/images/ai.png');
    // File imageFile = await getImageFileFromAssets('assets/images/433.png');
    // File imageFile = await getImageFileFromAssets('assets/images/433.png');
    // File imageFile = await getImageFileFromAssets('assets/images/433.png');
    // Uncomment and initialize other images if needed
    // File theDevilWorks = await getImageFileFromAssets('assets/TheDevilWorks.png');
    // File circle = await getImageFileFromAssets('assets/welcomeMail/circle.png');
    // File section2 = await getImageFileFromAssets('assets/welcomeMail/section2.png');
    // File jumpRightIn = await getImageFileFromAssets('assets/welcomeMail/jumpRightIn.png');
    // File appStore = await getImageFileFromAssets('assets/welcomeMail/appStore.png');
    // File playStore = await getImageFileFromAssets('assets/welcomeMail/playStore.png');

    final message = Message()
      ..from = Address(username, 'BLOOM')
      ..recipients.add('dishaj644@gmail.com')
      ..subject = 'Welcome to BLOOM'
      ..html = '''
    <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            color: #333333;
        }

        .container {
            width: 100%;
            max-width: 600px;
            margin: 20px auto;
            background-color: #ffffff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .header {
            background-color: #222;
            padding: 20px;
            text-align: center;
            color: #ffffff;
        }

        .header h1 {
            font-size: 28px;
            letter-spacing: 1px;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .header img.banner-image {
            width: auto;
            height: 100px;
            margin-left: 5px;
            vertical-align: middle;
        }

        .content {
            padding: 20px;
            line-height: 1.6;
        }

        .content h2 {
            color: #333;
            font-size: 24px;
            display: inline-block;
            vertical-align: middle;
            margin: 0;
        }

        .content img.logo {
            max-width: 60px;
            vertical-align: middle;
            margin-left: 10px;
        }

        .content p {
            color: #555;
            line-height: 1.8;
            font-size: 16px;
            margin-bottom: 16px;
        }

        .cta {
            margin-top: 20px;
            text-align: center;
        }

        .cta a {
            background-color: #fe7e05;
            color: #ffffff;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }

        .cta a:hover {
            background-color: #e67300;
        }

        .footer {
            background-color: #222;
            color: #ffffff;
            text-align: center;
            padding: 15px;
            font-size: 14px;
        }

        .footer p {
            margin: 0;
        }

        /* Responsive styles */
        @media (max-width: 600px) {
            .header h1 {
                font-size: 22px;
            }

            .content h2 {
                font-size: 20px;
            }

            .content img.logo {
                max-width: 30px;
            }

            .cta a {
                padding: 10px 20px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Welcome to <img src="https://i.ibb.co/bWDXxFx/IMG-2016.png" alt="BLOOM" class="banner-image"></h1>
        </div>

        <div class="content">
            <h2>Hi there!</h2>
            <img src="https://i.ibb.co/GxQYTtS/IMG-2003.png" alt="BLOOM Logo" class="logo">
            
            <p>Welcome to <b>Bloom</b>—we’re so excited to have you on board!</p>
            <p>Bloom is more than just an app. It’s a community where youth mentors, corporate partners, and eager learners come together to create skill-building events that make a real impact. Here’s how we do it, together with YOU</p>
           <p> <b>For Learners:</b> Bloom opens doors to practical skills and hands-on experiences. It’s learning beyond the classroom, where each child’s unique way of learning matters.</p>
            
           <p> <b>For Mentors:</b> You get to teach and share what you know while building your own skills and career path. Guiding others is one of the best ways to grow yourself!</P>
            
            <p> <b>For Venue Partners:</b> You’ll make your space a hub of positive change, helping the community while creating real social impact.</p>
            <br>
             <p>   Every event we create together is a chance to learn, connect, and bloom. 🌸 If you ever need help or just want to chat about ideas, we’re right here.</p>

             <p>Thanks for being part of something amazing!</p>
            <br>
             <p>With excitement,</p>
             <p>The Bloom Team</p>
            
            <div class="cta">
                <a href="#">Get Started with BLOOM</a>
            </div>
        </div>

        <div class="footer">
            <p>&copy; 2024 BLOOM. All rights reserved.</p>
        </div>
    </div>
</body>
</html>


    '''
      ..attachments = [
        FileAttachment(imageFile)
        //..location = Location.inline
        //..cid = 'image1@your-emails.com',FileAttachment(imageFile)
        //..location = Location.inline
        //..cid = 'image2@your-emails.com',FileAttachment(Ai)
        //..location = Location.inline
        //..cid = 'image3@your-emails.com',FileAttachment(imageFile)
        //..location = Location.inline
        //..cid = 'image41@your-emails.com',
        // Add other attachments here if needed
        // FileAttachment(theDevilWorks)
        //   ..location = Location.inline
        //   ..cid = 'image2@your-emails.com',
        // FileAttachment(circle)
        //   ..location = Location.inline
        //   ..cid = 'image3@your-emails.com',
        // FileAttachment(section2)
        //   ..location = Location.inline
        //   ..cid = 'image4@your-emails.com',
        // FileAttachment(jumpRightIn)
        //   ..location = Location.inline
        //   ..cid = 'image5@your-emails.com',
        // FileAttachment(appStore)
        //   ..location = Location.inline
        //   ..cid = 'image6@your-emails.com',
        // FileAttachment(playStore)
        //   ..location = Location.inline
        //   ..cid = 'image7@your-emails.com',
      ];

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      await send(message, smtpServer);
      print("Email Sent successfully");
      return true;
    } catch (e) {
      print('Message not sent. Error: $e');
      return false;
    }
  }

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
      final userDoc = usersCollection.doc(uid);

      await userDoc.update({
        'isVerified': status,
      });

      final verificationCollection = _firestore.collection('verification');

      final querySnapshot =
          await verificationCollection.where('uid', isEqualTo: uid).get();

      if (querySnapshot.docs.isNotEmpty) {
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
