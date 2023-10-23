import 'package:flutter/material.dart';
import 'package:wizedo/components/CustomRichText.dart';
import 'package:wizedo/components/searchable_dropdown.dart';
import 'package:wizedo/components/white_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF211B2E),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20,top: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomRichText(
                            firstText: 'Peer',
                            secondText: 'mate',
                            firstColor: Colors.white,
                            secondColor: Color(0xFF955AF2),
                            firstFontSize: 25,
                            secondFontSize: 25,
                          ),
                          WhiteText('Learn Together, Achieve Together')
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10,right: 10),
                      child: Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Floating Action Button
                            Container(
                              width: 52.0,
                              height: 52.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Container(
                                  width: 46.0,
                                  height: 46.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFF955AF2).withOpacity(0.1),

                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 36.0,
                                      height: 36.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xFF955AF2).withOpacity(0.1),
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 26,
                                          height: 26,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Color(0xFF39304D).withOpacity(0.9),
                                          ),
                                          child: FloatingActionButton(
                                            backgroundColor: Colors.transparent,
                                            onPressed: () {
                                              // Add your onPressed logic here
                                              print('Redirected to Post Page');
                                            },
                                            tooltip: 'Increment',
                                            child: Icon(Icons.notifications_on_rounded, color: Colors.white, size: 15.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25,right: 20,left: 20,bottom: 10),
              child: SearchableDropdownTextField(
                items: [
                  'Bachelor of Arts (BA)',
                  'Bachelor of Science (BSc)',
                  'Bachelor of Commerce (BCom)',
                  'Bachelor of Technology (BTech)',
                  'Bachelor of Business Administration (BBA)',
                  'Bachelor of Computer Applications (BCA)',
                  'Bachelor of Education (BEd)',
                  'Bachelor of Medicine, Bachelor of Surgery (MBBS)',
                  'Bachelor of Dental Surgery (BDS)',
                  'Bachelor of Pharmacy (BPharm)',
                  'Bachelor of Law (LLB)',
                  'Master of Arts (MA)',
                  'Master of Science (MSc)',
                  'Master of Commerce (MCom)',
                  'Master of Technology (MTech)',
                  'Master of Business Administration (MBA)',
                  'Master of Computer Applications (MCA)',
                  'Master of Social Work (MSW)',
                  'Master of Education (MEd)',
                  'Doctor of Philosophy (PhD)',
                  'Chartered Accountancy (CA)',
                  'Company Secretary (CS)',
                  'Cost and Management Accountancy (CMA)',
                ],
                labelText: 'Search',
                onSelected: (selectedItem) {
                  // Handle the selected item here
                  print('Selected item: $selectedItem');
                },
                suffix: Icon(Icons.search_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                width: 350,
                height: 45,
              ),
            ),

            //to select category
            Row()
          ],
        ),
      ),
    );
  }
}
