import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define a new stateless widget for Message Input
class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback sendMessage;

  const MessageInput({
    required this.controller,
    required this.focusNode,
    required this.sendMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 0, right: 0, left: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: GoogleFonts.mPlusRounded1c(
                textStyle: const TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 14,
                ),
              ),
              controller: controller,
              cursorHeight: 25,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              focusNode: focusNode,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Send Message...',
                labelStyle: GoogleFonts.mPlusRounded1c(
                  textStyle: const TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 14,
                  ),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFF21215E)),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 10),
            child: InkWell(
              onTap: sendMessage,
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF21215E).withOpacity(0.7),
                ),
                child: const Icon(Icons.send_rounded, size: 23, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

