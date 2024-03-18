import 'package:flutter/material.dart';
import 'package:wizedo/Widgets/colors.dart';

import '../components/mPlusRoundedText.dart';

class RefundAndCancellation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Refund And Cancellation',
          style: mPlusRoundedText.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20,left: 20,right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Refund And Cancellation Policy',style: TextStyle(fontSize: screenHeight > 600 ? 15 : 14,color: Colors.red),),
              SizedBox(height: 10,),
              Text('Last updated on 18-03-2024 14:59:10',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),),
              SizedBox(height: 10,),
              Text('SCANPICK PRIVATE LIMITED believes in helping its customers as far as possible, and has therefore a liberal cancellation policy. Under this policy:',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),),
              SizedBox(height: 10,),
              Text('• Cancellations will be considered only if the request is made immediately after placing the order. However, the cancellation request may not be entertained if the orders have been communicated to the vendors/merchants and they have initiated the process of shipping them.',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),),
              SizedBox(height: 10,),
              Text('• SCANPICK PRIVATE LIMITED does not accept cancellation requests for perishable items like flowers, eatables etc. However, refund/replacement can be made if the customer establishes that the quality of product delivered is not good.',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),),
              SizedBox(height: 10,),
              Text('• In case of receipt of damaged or defective items please report the same to our Customer Service team. The request will, however, be entertained once the merchant has checked and determined the same at his own end. This should be reported within 2 Days days of receipt of the products. In case you feel that the product received is not as shown on the site or as per your expectations, you must bring it to the notice of our customer service within 2 Days days of receiving the product. The Customer Service Team after looking into your complaint will take an appropriate decision.',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),),
              SizedBox(height: 10,),
              Text('• In case of complaints regarding products that come with a warranty from manufacturers, please refer the issue to them. In case of any Refunds approved by the SCANPICK PRIVATE LIMITED, it’ll take 1-2 Days days for the refund to be processed to the end customer.',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
