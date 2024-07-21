import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final bool isPast;
  final child;
  const EventCard({
    super.key,
    required this.isPast,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    Color customPrimaryColor = const Color(0xFF955AF2); // Custom color from hex code

    return Container(
      margin: const EdgeInsets.all(22),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isPast? customPrimaryColor:Colors.deepPurple.shade100
      ),
      child: child,
    );
  }
}
