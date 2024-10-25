import 'package:audioplayers/audioplayers.dart';
import 'package:bloom/form.dart';
import 'package:bloom/model/user.dart';
import 'package:bloom/screens/events/verify_event_detail.dart';
import 'package:bloom/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconly/iconly.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vibration/vibration.dart';

class EventDetailScreen extends StatefulWidget {
  final Map<String, dynamic> event;

  const EventDetailScreen({super.key, required this.event});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final AudioPlayer _audioCache = AudioPlayer(); // Use AudioCache for assets
  final _box = GetStorage(); // Initialize GetStorage
  UserModel? userData;
  bool isApplied = false; // Tracks whether user has applied

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from local storage
  void _fetchUserData() {
    final userDataMap = _box.read('userData') as Map<String, dynamic>?;
    if (userDataMap != null) {
      setState(() {
        userData = UserModel.fromMap(userDataMap);
        _checkIfApplied(); // Check if the user has already applied to the event
      });
    }
  }

  // Check if the current user is in the attendees list
  Future<void> _checkIfApplied() async {
    final eventDocRef = FirebaseFirestore.instance
        .collection('Events')
        .doc(widget.event['UID']);

    if (userData!.role == "Learner") {
      final eventSnapshot = await eventDocRef.get();
      final attendees = List.from(eventSnapshot.data()?['attendees'] ??
          []); // Check if the user is already in the attendees list
      setState(() {
        isApplied =
            attendees.any((attendee) => attendee['userId'] == userData!.uid);
      });
    } else {
      final eventSnapshot = await eventDocRef.get();
      final volunteers = List.from(eventSnapshot.data()?['volunteers'] ??
          []); // Check if the user is already in the volunteers list
      setState(() {
        isApplied =
            volunteers.any((attendee) => attendee['userId'] == userData!.uid);
      });
    }
  }

  Future<void> _onCodeScanned(BarcodeCapture barcodeCapture) async {
    if (barcodeCapture.barcodes.isNotEmpty) {
      final barcode = barcodeCapture.barcodes.first;

      // Split the QR code data assuming it's in the format "eventId,userId"
      final qrData = barcode.rawValue?.split(',');
      if (qrData == null || qrData.length != 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid QR code format')),
        );
        return;
      }
      final String scannedEventId = qrData[0]; // The eventId part
      final String scannedUserId = qrData[1]; // The userId part
      print(scannedEventId);
      print(scannedEventId);
      print(scannedEventId);
      print(scannedEventId);
      print(scannedEventId);
      print(scannedEventId);
      print(scannedUserId);
      print(scannedUserId);
      print(scannedUserId);
      print(scannedUserId);
      print(scannedUserId);

//UNIQUE SCANNER FOR EACH EVENT
      // Check if the scanned eventId matches the current event
      if (scannedEventId != widget.event['UID']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('QR code does not match this event')),
        );
        return;
      }
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      // Get the event document using the eventId
      DocumentReference eventRef =
          _firestore.collection('Events').doc(scannedEventId);
      DocumentReference userDoc =
          _firestore.collection('users').doc(scannedUserId);

      final eventSnapshot = await eventRef.get();

      if (!eventSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event not found')),
        );
        return;
      }

      // Cast the event data to Map<String, dynamic>
      final eventData = eventSnapshot.data() as Map<String, dynamic>;

      if (userData!.role == "Learner") {
        List<dynamic> attendees = eventData['attendees'] ?? [];

        // Find the attendee with the scanned userId
        bool userIsAttendee = false;
        for (var attendee in attendees) {
          if (attendee['userId'] == scannedUserId) {
            attendee['status'] = 'Present'; // Mark as present
            userIsAttendee = true;
            break;
          }
        }
        if (userIsAttendee) {
          // Update the event with the modified attendees list
          await eventRef.update({'attendees': attendees});
          await userDoc.update({
            'attendedEvents': FieldValue.arrayUnion([scannedEventId]),
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Successfully checked in user with ID: $scannedUserId')),
          );
          Navigator.pop(context); // Optionally close the scanner screen
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('User not found in the attendee list')),
          );
        }
      }
      if (userData!.role != "Learner") {
        List<dynamic> volunteers = eventData['volunteers'] ?? [];

        bool userIsAttendee = false;
        for (var volunteer in volunteers) {
          if (volunteer['userId'] == scannedUserId) {
            volunteer['status'] = 'Present'; // Mark as present
            userIsAttendee = true;
            break;
          }
        }
        if (userIsAttendee) {
          // Update the event with the modified volunteers list
          await eventRef.update({'volunteers': volunteers});
          await userDoc.update({
            'attendedEvents': FieldValue.arrayUnion([scannedEventId]),
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Successfully checked in user with ID: $scannedUserId')),
          );
          Navigator.pop(context); // Optionally close the scanner screen
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('User not found in the attendee list')),
          );
        }
      }
    }
  }

  // Add userId to the event's attendee list in Firestore
  Future<void> _rsvpToEvent(String eventId, String role) async {
    final eventDocRef =
        FirebaseFirestore.instance.collection('Events').doc(eventId);
    try {
      if (isApplied) {
        if (role == "Learner") {
          await eventDocRef.update({
            'attendees': FieldValue.arrayRemove([
              {'userId': userData!.uid, 'status': 'Applied'}
            ])
          });
        }
        // Remove user from attendees
        // if (role == "Mentor") {
        else {
          await eventDocRef.update({
            'volunteers': FieldValue.arrayRemove([
              {'userId': userData!.uid, 'status': 'Applied'}
            ])
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You have successfully removed your RSVP.')),
        );
      } else {
        // Add user to attendees
        if (role == "Learner") {
          await eventDocRef.update({
            'attendees': FieldValue.arrayUnion([
              {'userId': userData!.uid, 'status': 'Applied'}
            ])
          });
        } else {
          await eventDocRef.update({
            'volunteers': FieldValue.arrayUnion([
              {'userId': userData!.uid, 'status': 'Applied'}
            ])
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You have successfully RSVP\'d to this event!')),
        );
      }

      // Play sound and vibrate
      await _audioCache
          .setSource(AssetSource('success2.mp3')); // Load the sound
      _audioCache.resume(); // Play the sound
      if (await Vibration.hasVibrator() != null) {
        Vibration.vibrate(duration: 500); // Vibrate for 500 milliseconds
      }

      // Toggle the applied state
      setState(() {
        isApplied = !isApplied;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update RSVP: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event['name'] ?? 'Event Detail'),
        actions: [
          IconButton(
            icon: const Icon(IconlyBroken.scan),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      QRScannerScreen(onCodeScanned: _onCodeScanned),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                if (isApplied)
                  Container(
                    // height: 250,
                    child: Stack(
                      children: [
                        Center(
                          child: SvgPicture.asset(
                            "assets/svg/ticketBg-2.svg",
                            height: 300,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            Center(
                              child: QrImageView(
                                data: widget.event['UID'] + "," + userData!.uid,
                                version: QrVersions.auto,
                                size: 125.0,
                              ),
                            ),
                            const SizedBox(
                              height: 75,
                            ),
                            const Text("1x Admit")
                          ],
                        ),
                      ],
                    ),
                  ),
                ListTile(
                  title: Text(userData!.uid),
                ),
                ListTile(
                  title: const Text('Name'),
                  subtitle: Text(widget.event['name'] ?? 'No name'),
                ),
                ListTile(
                  title: const Text('Date'),
                  subtitle: Text(widget.event['date'] ?? 'No date'),
                ),
                ListTile(
                  title: const Text('Time'),
                  subtitle: Text(widget.event['time'] ?? 'No time'),
                ),
                ListTile(
                  title: const Text('Venue'),
                  subtitle: Text(widget.event['venue'] ?? 'No venue'),
                ),
                ListTile(
                  title: const Text('City'),
                  subtitle: Text(widget.event['city'] ?? 'No city'),
                ),
                ListTile(
                  title: const Text('Contact'),
                  subtitle: Text(widget.event['contact'] ?? 'No contact'),
                ),
                ListTile(
                  title: const Text('Organizer'),
                  subtitle: Text(widget.event['organizer'] ?? 'No organizer'),
                ),
                ListTile(
                  title: const Text('Description'),
                  subtitle:
                      Text(widget.event['description'] ?? 'No description'),
                ),
                ListTile(
                  title: const Text('Special Instructions'),
                  subtitle: Text(
                      widget.event['specialInstruction'] ?? 'No instructions'),
                ),
                ListTile(
                  title: const Text('Perks'),
                  subtitle: Text(widget.event['perks'] ?? 'No perks'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                userData != null
                    ? GestureDetector(
                        onTap: () {
                          _rsvpToEvent(
                              widget.event['UID'],
                              userData!
                                  .role); // Assuming UID is the event document ID
                        },
                        child: userData!.role == "Learner"
                            ? CustomButton(
                                name: isApplied
                                    ? "Applied as attendee"
                                    : "Apply as attendee",
                                color: orange)
                            : CustomButton(
                                name: isApplied
                                    ? "Applied as collaborator"
                                    : "Apply as collaborator",
                                color: isApplied ? primaryWhite : orange))
                    : const Center(
                        child: Text('Please log in to Apply'),
                      ),
                const SizedBox(
                  height: 47,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
