import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildLabel(String text) {
  return Text(
    text,
    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
  );
}

Widget buildTextBox(String text) {
  return TextField(
    enabled: false,
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      hintText: text,
    ),
  );
}