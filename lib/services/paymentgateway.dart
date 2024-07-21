import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../components/debugcusprint.dart';

class StatusPage extends StatefulWidget {
  final String? postId;
  final int? priceRange;

  const StatusPage({
    super.key,
    this.postId,
    this.priceRange,
  });

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> initiatePayment() async {
    final url = Uri.parse('http://your_server_ip:3000/initiate-payment');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'priceRange': widget.priceRange,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final orderId = responseData['orderId'];
      final orderAmount = responseData['orderAmount'];

      // Handle payment initiation success, proceed with Razorpay integration
    } else {
      // Handle payment initiation failure
      debugLog('Failed to initiate payment: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Price: ${widget.priceRange}'),
            ElevatedButton(
              onPressed: initiatePayment,
              child: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
