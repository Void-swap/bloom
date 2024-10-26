import 'package:bloom/screens/events/verify_event_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VerifyEventScreen extends StatefulWidget {
  const VerifyEventScreen({super.key});

  @override
  _VerifyEventScreenState createState() => _VerifyEventScreenState();
}

class _VerifyEventScreenState extends State<VerifyEventScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _eventsStream;

  @override
  void initState() {
    super.initState();
    _eventsStream = _firestore
        .collection('Events')
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  Future<void> _verifyEvent(String eventId) async {
    await _firestore
        .collection('Events')
        .doc(eventId)
        .update({'status': 'live'});
  }

  Future<void> _rejectEvent(String eventId) async {
    await _firestore
        .collection('Events')
        .doc(eventId)
        .update({'status': 'rejected'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Events'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _eventsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No pending events.'));
          }

          final events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final eventId = event.id;
              final eventName = event['name'] ?? 'No Name';
              final eventDescription = event['description'] ?? 'No Description';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerifyEventDetail(
                        eventId: eventId,
                        eventName: eventName,
                        eventDescription: eventDescription,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(eventName),
                    subtitle: Text(eventDescription),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () => _verifyEvent(eventId),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () => _rejectEvent(eventId),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
