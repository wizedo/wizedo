import 'package:flutter/material.dart';
import 'package:wizedo/components/white_text.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActiveCard extends StatelessWidget {
  final String subject;
  final Timestamp? createdAt; // Keep as Timestamp?
  final String priceRange;

  const ActiveCard({super.key, 
    required this.subject,
    required this.createdAt,
    required this.priceRange,
  });

  String formatDate(Timestamp? createdAt) {
    if (createdAt == null) {
      print(createdAt);

      return 'N/A'; // Return a default value for null dates
    }

    DateTime date = createdAt.toDate();

    // Format the date
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.transparent, Color(0xFF14141E)],
            stops: [0.1, 1],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: WhiteText(
                      subject,
                      fontSize: 12,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
                ],
              ),
              const SizedBox(height: 5.0),
              WhiteText(
                formatDate(createdAt),
                fontSize: 9,
              ),
              const SizedBox(height: 2.0),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurple, // Circle color
                    ),
                    padding: const EdgeInsets.all(3), // Padding for the circle
                    child: const Icon(Icons.timelapse_rounded, color: Colors.white, size: 14),
                  ),
                  const SizedBox(width: 10), // Adjust spacing as needed
                  const WhiteText(
                    'waiting for applicant',
                    fontSize: 12,
                  ),
                  const Spacer(),
                  WhiteText(
                    'Rs. ${priceRange.toString()}',
                    fontSize: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
