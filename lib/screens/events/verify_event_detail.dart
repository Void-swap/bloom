import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class VerifyEventDetail extends StatefulWidget {
  final String eventId;
  final String eventName;
  final String eventDescription;

  const VerifyEventDetail({
    required this.eventId,
    required this.eventName,
    required this.eventDescription,
  });

  @override
  _VerifyEventDetailState createState() => _VerifyEventDetailState();
}

class _VerifyEventDetailState extends State<VerifyEventDetail> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GetStorage _storage = GetStorage();

  Future<void> _verifyEvent() async {
    await _firestore
        .collection('Events')
        .doc(widget.eventId)
        .update({'status': 'live'});
    Navigator.pop(context);
  }

  Future<void> _rejectEvent() async {
    await _firestore
        .collection('Events')
        .doc(widget.eventId)
        .update({'status': 'rejected'});
    Navigator.pop(context);
  }

  Future<void> _onCodeScanned(BarcodeCapture barcodeCapture) async {
    if (barcodeCapture.barcodes.isNotEmpty) {
      final barcode = barcodeCapture.barcodes.first;

      final qrData = barcode.rawValue?.split(',');
      if (qrData == null || qrData.length != 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid QR code format')),
        );
        return;
      }
      final String scannedEventId = qrData[0];
      final String scannedUserId = qrData[1];
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

      // if (s
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

      final eventData = eventSnapshot.data() as Map<String, dynamic>;

      List<dynamic> attendees = eventData['attendees'] ?? [];

      bool userIsAttendee = false;
      for (var attendee in attendees) {
        if (attendee['userId'] == scannedUserId) {
          attendee['status'] = 'Present';
          userIsAttendee = true;
          break;
        }
      }

      if (userIsAttendee) {
        await eventRef.update({'attendees': attendees});
        await userDoc.update({
          'attendedEvents': FieldValue.arrayUnion([scannedEventId]),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Successfully checked in user with ID: $scannedUserId')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found in the attendee list')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventName),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Event Name: ${widget.eventName}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 8.0),
            Text(
              'Description: ${widget.eventDescription}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 16.0),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _verifyEvent,
                  child: Text('Accept'),
                ),
                ElevatedButton(
                  onPressed: _rejectEvent,
                  child: Text('Reject'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QRScannerScreen extends StatefulWidget {
  final Function(BarcodeCapture) onCodeScanned;

  const QRScannerScreen({required this.onCodeScanned});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isBackCamera = true;
  bool isFlashOn = false;
  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   // title: const Text('QR Scanner'),
      //   actions: [
      //     IconButton(
      //       icon: Icon(
      //         isFlashOn ? Icons.flash_on : Icons.flash_off,
      //         color: Colors.white,
      //       ),
      //       onPressed: () {
      //         setState(() {
      //           isFlashOn = !isFlashOn;
      //           cameraController.toggleTorch();
      //         });
      //       },
      //     ),
      //     IconButton(
      //       icon: Icon(
      //         isBackCamera ? Icons.camera_rear : Icons.camera_front,
      //         color: Colors.white,
      //       ),
      //       onPressed: () {
      //         setState(() {
      //           isBackCamera = !isBackCamera;
      //           cameraController.switchCamera();
      //         });
      //       },
      //     ),
      //   ],
      // ),

      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (BarcodeCapture barcodeCapture) {
              if (barcodeCapture.barcodes.isNotEmpty) {
                widget.onCodeScanned(barcodeCapture);
                _showSuccessFeedback();
              }
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isFlashOn = !isFlashOn;
                        cameraController.toggleTorch();
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      isBackCamera ? Icons.camera_rear : Icons.camera_front,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isBackCamera = !isBackCamera;
                        cameraController.switchCamera();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Lottie.asset(
              'assets/lottie/qrScanner.json',
              // width: 250,
              height: 325,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Scan Volunteers QR code',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.8),
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessFeedback() {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Row(
    //         children: const [
    //           Icon(Icons.check_circle, color: Colors.green),
    //           SizedBox(width: 10),
    //           Text('QR code scanned successfully!'),
    //         ],
    //       ),
    //       duration: const Duration(seconds: 2),
    //     ),
    //   );
  }
}
