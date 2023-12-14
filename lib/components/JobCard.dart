import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:intl/intl.dart';

class JobCard extends StatefulWidget {
  final String category;
  final String subject;
  final Timestamp  date;
  final String description;
  final int priceRange; // Change to int
  final String userName;
  final DateTime finalDate; // Add this line

  JobCard({
    required this.category,
    required this.subject,
    required this.date,
    required this.description,
    required this.priceRange,
    required this.userName,
    required this.finalDate, // Add this line
  });

  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  bool isBookmarked = false;

  String getTimeAgo(DateTime dateTime) {
    return GetTimeAgo.parse(dateTime); // Assuming GetTimeAgo can parse DateTime objects
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 370,
      height: 150,
      child: Stack(
        children: [
          Card(
            margin: EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.transparent,
            elevation: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.transparent, Color(0xFF14141E)],
                  stops: [0.1, 1],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.subject}',
                      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    //date
                    Text(
                      '${getTimeAgo(widget.finalDate)}',
                      style: TextStyle(color: Colors.grey, fontSize: 8.0),
                    ),

                    SizedBox(height: 8.0),
                    Text(
                      widget.description.length > 100
                          ? '${widget.description.substring(0, 100)}...' // Display only first 70 characters
                          : widget.description,
                      style: TextStyle(fontSize: 10.0, color: Colors.white),
                    ),
                    SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Price: ${widget.priceRange}', // Assuming price is in dollars
                          style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          '~${widget.userName}',
                          style: TextStyle(fontSize: 8.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: -10,
            top: -10,
            child: Padding(
              padding: const EdgeInsets.only(right: 25),
              child: IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? Color(0xFF955AF2) : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    isBookmarked = !isBookmarked;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }




}