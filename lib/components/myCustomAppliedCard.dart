import 'package:flutter/material.dart';
import 'package:wizedo/components/white_text.dart';

class MyCustomCard extends StatelessWidget {
  final String subject;
  final String date;
  final String description;
  final String priceRange;
  final IconData icon;

  MyCustomCard({
    required this.subject,
    required this.date,
    required this.description,
    required this.priceRange,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: WhiteText(
                      subject,
                      fontSize: 12, // Set text color to white
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, color: Colors.white), // Set icon color to white
                ],
              ),
              SizedBox(height: 5.0),
              // 'Rs. ${priceRange.toString()}',

              WhiteText(
                date,
                fontSize: 9,
              ),

              SizedBox(height: 2.0),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              Row(
                children: [
                  Icon(Icons.museum_rounded, color: Colors.deepPurple, size: 18,),
                  SizedBox(width: 5),
                  WhiteText(
                    'On Progress',
                    fontSize: 12,
                  ),
                  Spacer(),
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
