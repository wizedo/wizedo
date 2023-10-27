import 'package:flutter/material.dart';

Decoration cardContainerdecoration = BoxDecoration(
  color: Color(0xFF261D3C),
  borderRadius: BorderRadius.circular(15),
);

class cardSettingContainer extends StatelessWidget {
  final String text;
  final IconData iconData; // Use IconData instead of Icon

  const cardSettingContainer({
    Key? key,
    required this.text,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(5),
        width: 110,
        height: 110,
        decoration: cardContainerdecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(height: 5),
            Text(
              text,
              style: TextStyle(color: Colors.white,fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
