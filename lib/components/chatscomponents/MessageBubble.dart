import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String senderId;
  final DateTime timestamp;
  final bool isCurrentUser;
  final bool isLastMessage;

  const MessageBubble({
    required this.message,
    required this.senderId,
    required this.timestamp,
    required this.isCurrentUser,
    required this.isLastMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    // Determine the background color based on the sender's ID
    Color bubbleColor = isCurrentUser
        ? const Color(0xFF21215E).withOpacity(0.7) // User sending the message
        : Colors.white.withOpacity(0.5); // User receiving the message

    Color textColor = isCurrentUser ? Colors.white : const Color(0xFF21215E);
    Color borderColor = isCurrentUser ? Colors.white : const Color(0xFF21215E);

    // Determine the border radius based on the sender's ID
    BorderRadiusGeometry borderRadius = isCurrentUser
        ? const BorderRadius.only(
      topLeft: Radius.circular(18),
      topRight: Radius.circular(18),
      bottomLeft: Radius.circular(18),
      bottomRight: Radius.circular(0.4),
    )
        : const BorderRadius.only(
      topLeft: Radius.circular(0.4),
      topRight: Radius.circular(18),
      bottomLeft: Radius.circular(18),
      bottomRight: Radius.circular(18),
    );

    // Determine the alignment and padding based on sender's ID
    CrossAxisAlignment crossAlignment = isCurrentUser
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    double leftPadding = isCurrentUser
        ? MediaQuery.of(context).size.width * 0.15 // 15% of screen width for sent messages
        : 0; // No left padding for received messages

    double rightPadding = isCurrentUser
        ? 0 // No right padding for sent messages
        : MediaQuery.of(context).size.width * 0.15; // 15% of screen width for received messages

    EdgeInsets padding = isCurrentUser
        ? EdgeInsets.fromLTRB(leftPadding, 10.0, rightPadding, 10.0)
        : EdgeInsets.fromLTRB(leftPadding, 10.0, rightPadding, 10.0);

    return Container(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: crossAlignment,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: bubbleColor,
                  boxShadow: [
                    if (!isLastMessage) // Apply box shadow only if it's not the last message
                      BoxShadow(
                        color: const Color(0xFF21215E).withOpacity(0.61),
                        blurRadius: 80.0,
                      ),
                  ],
                ),
                child: Text(
                  message,
                  style: TextStyle(fontSize: 14, color: textColor),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('hh:mm a').format(timestamp),
                style: const TextStyle(fontSize: 8, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
