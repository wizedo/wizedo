import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Widgets/colors.dart';
import '../components/mPlusRoundedText.dart';

class acceptedJobs extends StatelessWidget {
  const acceptedJobs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Pending Works',
          style: mPlusRoundedText.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
    );
  }
}
