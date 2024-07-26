import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:wizedo/components/white_text.dart';
import 'package:get/get.dart';

class JobCard extends StatefulWidget {
  final String category;
  final String subject;
  final Timestamp date;
  final String description;
  final int priceRange; // Change to int
  final String userName;
  final DateTime finalDate; // Add this line

  const JobCard({super.key,
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
    return GetTimeAgo.parse(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    double cardHeight = Get.height < 600 ? Get.height * 0.32 : 150;

    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        double cardWidth = sizingInformation.screenSize.width * 0.9;

        return SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Stack(
            children: [
              Card(
                margin: const EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: Colors.transparent,
                elevation: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
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
                        WhiteText(
                          widget.subject,
                          fontSize: sizingInformation.screenSize.width > 600 ? 16.0 : 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                        //date
                        WhiteText(
                          getTimeAgo(widget.finalDate),
                          fontSize: sizingInformation.screenSize.width > 600 ? 12.0 : 8.0,
                          textColor: Colors.grey.shade500,
                        ),
                        SizedBox(height: sizingInformation.screenSize.width > 600 ? 12.0 : 8.0),
                        Expanded(
                          child: WhiteText(
                            widget.description.length > 100
                                ? '${widget.description.substring(0, 100)}...' // Display only first 100 characters
                                : widget.description,
                            fontSize: sizingInformation.screenSize.width > 600 ? 14.0 : 10.0,
                          ),
                        ),
                        SizedBox(height: sizingInformation.screenSize.width > 600 ? 16.0 : 12.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WhiteText(
                              'Rs. ${widget.priceRange}', // Assuming price is in dollars
                              fontSize: sizingInformation.screenSize.width > 600 ? 14.0 : 10.0,
                              fontWeight: FontWeight.bold,
                            ),
                            WhiteText(
                              '~${widget.userName}',
                              fontSize: sizingInformation.screenSize.width > 600 ? 12.0 : 8.0,
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
                      color: isBookmarked ? const Color(0xFF955AF2) : Colors.white,
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
      },
    );
  }
}