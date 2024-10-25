import 'package:bloom/model/venue.dart'; // Import your VenueModel
import 'package:flutter/material.dart';

class VenueDetailsScreen extends StatelessWidget {
  final VenueModel venue;

  VenueDetailsScreen({required this.venue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(venue.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Address: ${venue.address}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('City: ${venue.city}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Capacity: ${venue.capacity}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Description: ${venue.description}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Facilities: ${venue.facilities.join(', ')}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Contact Person: ${venue.contactPerson}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Contact Email: ${venue.contactEmail}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Contact Phone: ${venue.contactPhone}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Accessibility Info: ${venue.accessibilityInfo}',
                style: TextStyle(fontSize: 16)),
            // You can add more details as needed
          ],
        ),
      ),
    );
  }
}
