import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_slide_to_act/gradient_slide_to_act.dart';
import 'package:wizedo/Widgets/colors.dart';
import 'package:intl/intl.dart';
import 'package:wizedo/components/YearPickerTextField.dart';
import 'package:wizedo/components/datePickerTextField.dart';
import 'package:wizedo/components/mPlusRoundedText.dart';
import 'package:wizedo/components/my_text_field.dart';
import 'package:wizedo/components/searchable_dropdown.dart';
import 'package:wizedo/components/white_text.dart';

import '../components/boxDecoration.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _projectName = TextEditingController();
  final TextEditingController _descriptionText = TextEditingController();
  final TextEditingController _datePicker = TextEditingController();
  final TextEditingController _paymentDetails = TextEditingController();

  String _selectedCategory = '';
  bool _isNumberOfPagesVisible = false;

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Post',
          style: mPlusRoundedText.copyWith(fontSize: 33),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Select
            Text(
              'Category:',
              style: mPlusRoundedText.copyWith(fontSize: 12),
            ),
            SizedBox(height: 10),
            SearchableDropdownTextField(
              items: ['Assignment', 'Graphics', 'Coding', 'College Subject'],
              labelText: 'Select',
              onSelected: (selectedItem) {
                setState(() {
                  _selectedCategory = selectedItem;
                  _isNumberOfPagesVisible =
                      _selectedCategory == 'Assignment' || _selectedCategory == 'College Subject';
                });
                print('Selected item: $selectedItem');
              },
              suffix: Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
                size: 30,
              ),
            ),
            SizedBox(height: 10),
            // Project Name
            Text(
              'Project Name:',
              style: mPlusRoundedText.copyWith(fontSize: 12),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: MyTextField(
                controller: _projectName,
                obscureText: false,
                hint: 'Name',
                keyboardType: TextInputType.name,
              ),
            ),
            SizedBox(height: 10),
            // Description Field
            Text(
              'Description: ',
              style: mPlusRoundedText.copyWith(fontSize: 12),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 120,
              child: MyTextField(
                controller: _descriptionText,
                obscureText: false,
                hint: 'Write a brief of the description...',
                keyboardType: TextInputType.name,
              ),
            ),
            if (_isNumberOfPagesVisible)
              Column(
                children: [
                  // Total/Approx pages requiring assistance
                  Text(
                    'Total/Approx pages requiring assistance',
                    style: mPlusRoundedText.copyWith(fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 250,
                    child: MyTextField(
                      controller: _descriptionText,
                      obscureText: false,
                      hint: 'Number of pages',
                      keyboardType: TextInputType.name,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.info, color: Colors.blue),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 10),
            // Due Date
            Text(
              'Due Date: ',
              style: mPlusRoundedText.copyWith(fontSize: 12),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: Row(
                children: [
                  DateSelector(
                    controller: _datePicker,
                    hint: 'Select Date(yyyy-mm-dd)',
                    suffixIcon: Icon(
                      Icons.calendar_month,
                      color: Colors.deepPurple,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Upload a reference file: ',
              style: mPlusRoundedText.copyWith(fontSize: 12),
            ),
            SizedBox(height: 10),
            Container(
              decoration: boxDecoration,
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/images/pdf.png', width: 30),
                  SizedBox(width: 10),
                  WhiteText('Upload a file',
                      fontSize: 15, fontWeight: FontWeight.bold),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Total Pay:',
              style: mPlusRoundedText.copyWith(fontSize: 12),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: MyTextField(
                fontSize: 17,
                controller: _paymentDetails,
                obscureText: false,
                hint: 'Enter Expected pay',
                keyboardType: TextInputType.number,
                suffixIcon: Icon(Icons.currency_rupee, color: Colors.yellow),
              ),
            ),
            SizedBox(height: 20),
            GradientSlideToAct(
              borderRadius: 12,
              width: 400,
              onSubmit: (){},
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors:[
                    Colors.white,
                    Colors.deepPurple,
                  ]
              ),
              height: 50,
              backgroundColor: Colors.deepPurple,
            ),
          ],
        ),
      ),
    );
  }
}