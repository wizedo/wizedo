import 'package:flutter/material.dart';

class JobCard extends StatefulWidget {
  final String subject;
  final String postedTime;
  final String description;
  final String priceRange;
  final String userName;

  JobCard({
    required this.subject,
    required this.postedTime,
    required this.description,
    required this.priceRange,
    required this.userName,
  });

  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  bool isBookmarked = false;

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
                  stops: [0.1,1],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.subject,
                      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'Posted ${widget.postedTime}',
                      style: TextStyle(color: Colors.grey, fontSize: 8.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      widget.description,
                      style: TextStyle(fontSize: 10.0, color: Colors.white),
                    ),
                    SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Price: ${widget.priceRange}',
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
            right: -10, // Adjust the position to overlap half inside and half outside the card
            top: -10, // Adjust the position to overlap half inside and half outside the card
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
