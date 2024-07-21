// IconButton(
//   icon: Icon(Icons.delete_rounded, size: 16,),
//   onPressed: () {
//     Get.snackbar(
//       '', // Empty title for a transparent style
//       'Are you sure you want to delete this chat??',
//       snackPosition: SnackPosition.TOP,
//       duration: Duration(seconds: 6),
//       margin: EdgeInsets.only(top: 50, left: 10, right: 10),
//       backgroundColor: Colors.transparent,
//       borderRadius: 20,
//       mainButton: TextButton(
//         onPressed: () {
//           _chatController.deleteChat(widget.receiverUserID); // Pass the chatId
//           Get.back(); // Close the snackbar
//         },
//         child: Text(
//           'Yes',
//           style: TextStyle(color: Color(0xFF21215E)), // Change button text color
//         ),
//       ),
//     );
//   },
// ),