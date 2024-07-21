// import 'package:flutter/material.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
// import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
// import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: CashFreePayment(),
//     );
//   }
// }
//
// class CashFreePayment extends StatefulWidget {
//   const CashFreePayment({super.key});
//
//   @override
//   State<CashFreePayment> createState() => _CashFreePaymentState();
// }
//
// class _CashFreePaymentState extends State<CashFreePayment> {
//   CFPaymentGatewayService cfPaymentGatewayService =
//   CFPaymentGatewayService(); // Cashfree Payment Instance
//   bool? isSuccess;
//
//   @override
//   void initState() {
//     super.initState();
//     // Attach events when payment is success and when error occured
//     cfPaymentGatewayService.setCallback(verifyPayment, onError);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Cashfree Payment Flutter Template'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(onPressed: pay, child: const Text("Pay")),
//             Text(
//               "Payment Status $isSuccess",
//               style: const TextStyle(fontSize: 20),
//             )
//           ],
//         ),
//       ),
//     );
//   } // When payment is done successfully
//
//   void verifyPayment(String orderId) {
//     // Here we will only print the statement
//     // to check payment is done or not
//     isSuccess = true;
//     setState(() {});
//     print("Verify Payment $orderId");
//
//   }
//
//   // If some error occur during payment this will trigger
//   void onError(CFErrorResponse errorResponse, String orderId) {
//     // printing the error message so that we can show
//     // it to user or  checkourselves for testing
//     isSuccess = false;
//     setState(() {});
//     print(errorResponse.getMessage());
//     print("Error while making payment");
//   }
//
//   String orderId = "my_order_id1";
//
//   Future<CFSession?> createSession() async {
//     try {
//       final mySessionIDData = await createSessionID(
//           orderId); // This will create session id from flutter itself
//
//       // Now we will se some parameter like orderID ,environment,payment sessionID
//       // after that we wil create the checkout session
//       // which will launch through which user can pay.
//       var session = CFSessionBuilder()
//           .setEnvironment(CFEnvironment.SANDBOX)
//           .setOrderId(mySessionIDData["order_id"])
//           .setPaymentSessionId(mySessionIDData["payment_session_id"])
//           .build();
//       return session;
//     } on CFException catch (e) {
//       print(e.message);
//     }
//     return null;
//   }
//
//   pay() async {
//     try {
//       var session = await createSession();
//       List<CFPaymentModes> components = <CFPaymentModes>[];
//       // If you want to set paument mode to be shown to customer
//       var paymentComponent =
//       CFPaymentComponentBuilder().setComponents(components).build();
//       // We will set theme of checkout session page like fonts, color
//       var theme = CFThemeBuilder()
//           .setNavigationBarBackgroundColorColor("#FF0000")
//           .setPrimaryFont("Menlo")
//           .setSecondaryFont("Futura")
//           .build();
//       // Create checkout with all the settings we have set earlier
//       var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder()
//           .setSession(session!)
//           .setPaymentComponent(paymentComponent)
//           .setTheme(theme)
//           .build();
//       // Launching the payment page
//
//       cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
//     } on CFException catch (e) {
//       print(e.message);
//     }
//   }
//
// // webCheckout() async {
// //   try {
// //     var session = await createSession();
// //     var cfWebCheckout =
// //         CFWebCheckoutPaymentBuilder().setSession(session!).build();
// //     cfPaymentGatewayService.doPayment(cfWebCheckout);
// //   } on CFException catch (e) {
// //     print(e.message);
// //   }
// // }
// }
//
// createSessionID(String orderID) async {
//   var headers = {
//     'Content-Type': 'application/json',
//     'x-client-id': 'TEST4143386d2b7e9c0c011a9417ce833414',
//     'x-client-secret': 'cfsk_ma_test_2b4134285dfbd26fdbf4ad607a310941_693b2e03',
//     'x-api-version': '2022-09-01', // This is latest version for API
//     'x-request-id': 'fluterwings'
//   };
//   print(headers);
//   var request =
//   http.Request('POST', Uri.parse('https://sandbox.cashfree.com/pg/orders'));
//   request.body = json.encode({
//     "order_amount": 1, // Order Amount in Rupees
//     "order_id": orderID, // OrderiD created by you it must be unique
//     "order_currency": "INR", // Currency of order like INR,USD
//     "customer_details": {
//       "customer_id": "customer_id", // Customer id
//       "customer_name": "customer_name", // Name of customer
//       "customer_email": "flutterwings304@gmail.com", // Email id of customer
//       "customer_phone": "+917737366393" // Phone Number of customer
//     },
//     "order_meta": {"notify_url": "https://test.cashfree.com"},
//     "order_note": "some order note here" // If you want  to store something extra
//   });
//   request.headers.addAll(headers);
//
//   http.StreamedResponse response = await request.send();
//
//   if (response.statusCode == 200) {
//     // If All the details is correct it will return the
//     // response and you can get sessionid for checkout
//     return jsonDecode(await response.stream.bytesToString());
//   } else {
//     print(await response.stream.bytesToString());
//     print(response.reasonPhrase);
//   }
// }