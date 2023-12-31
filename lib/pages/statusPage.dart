import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:wizedo/components/my_timeline_tile.dart';

class statusPage extends StatefulWidget {
  const statusPage({super.key});

  @override
  State<statusPage> createState() => _statusPageState();
}

class _statusPageState extends State<statusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: ListView(
          children: [
            //start timeline
            MyTimeLineTile(
              isFirst: true,
              isLast: false,
              isPast:true,
              eventCard: Text('package shipped'),
            ),
            //middle timeline
            MyTimeLineTile(
                isFirst: false,
                isLast: false,
                isPast:true,
                eventCard: Text('package on the way'),

            ),
            //last timeline
            MyTimeLineTile(
                isFirst: false,
                isLast: true,
                isPast:false,
              eventCard: Text('Order Placed'),

            ),

          ],
        ),
      ),
    );
  }
}
