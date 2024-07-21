import 'package:flutter/material.dart';

Decoration cardContainerdecoration = BoxDecoration(
  color: const Color(0xFF231C30),
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      // spreadRadius: 1,
      blurRadius: 10,
      // offset: Offset(0, 50),
    ),
  ],
);

class cardSettingContainer extends StatelessWidget {
  final String text;
  final IconData iconData; // Use IconData instead of Icon

  const cardSettingContainer({
    super.key,
    required this.text,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(10),
        width: screenHeight < 600 ? 75 : 100,
        height: screenHeight < 600 ? 75 : 100,
        decoration: cardContainerdecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: screenHeight < 600 ? 16 : 25,
            ),
            const SizedBox(height: 5),
            Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: screenHeight < 600 ? 9 : 12),
            ),
          ],
        ),
      ),
    );
  }
}
