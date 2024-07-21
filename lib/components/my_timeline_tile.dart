import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:wizedo/components/event_card.dart';

class MyTimeLineTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final eventCard;
  const MyTimeLineTile({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.eventCard
  });

  @override
  Widget build(BuildContext context) {
    Color customPrimaryColor = const Color(0xFF955AF2); // Custom color from hex code

    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
          color: isPast ? customPrimaryColor:Colors.deepPurple.shade100),
      indicatorStyle: IndicatorStyle(
        width: 26,
        color: isPast ? customPrimaryColor:Colors.deepPurple.shade100,
        iconStyle: IconStyle(
          color: isPast? Colors.white : Colors.deepPurple.shade100,
          iconData: Icons.done_rounded,
        )
      ),


      //event card
      endChild: EventCard(
        isPast: isPast,
        child: eventCard,
      ),

    );
  }
}
