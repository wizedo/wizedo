import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wizedo/components/CustomRichText.dart';
import 'package:wizedo/components/searchable_dropdown.dart';
import 'package:wizedo/components/white_text.dart';
import 'package:shimmer/shimmer.dart';


import '../components/FliterChip.dart';
import '../components/JobCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'College Project';
  List<String> _technologyNews = ['Tech News 1', 'Tech News 2', 'Tech News 3'];
  List<String> _politicsNews = [
    'Politics News 1',
    'Politics News 2',
    'Politics News 3',
    'Politics News 4',
    'Politics News 5',
    'Politics News 6',
    'Politics News 7',
    'Politics News 8',
    'Politics News 9',
    'Politics News 10',
    'Politics News 11',
    'Politics News 12',
    'Politics News 13',
    'Politics News 14',
    'Politics News 15',
    'Politics News 16',
    'Politics News 17',
    'Politics News 18',
    'Politics News 19',
    'Politics News 20',
  ];

  List<String> _scienceNews = ['Science News 1', 'Science News 2', 'Science News 3'];


  @override
  Widget build(BuildContext context) {
    List<String> selectedCategoryNews;
    if (_selectedCategory == 'College Project') {
      selectedCategoryNews = _technologyNews;
    } else if (_selectedCategory == 'Personal Development') {
      selectedCategoryNews = _politicsNews;
    } else {
      selectedCategoryNews = _scienceNews;
    }

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
                            firstFontSize: 20,
                            secondFontSize: 20,
                          ),
                          WhiteText('Learn Together, Achieve Together',fontSize: 12,)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5,right: 10),
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

            Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5,left: 50),
                    child: Row(
                      children: [
                        FilterChipWidget(
                          label: 'College Project',
                          selectedCategory: _selectedCategory,
                          onTap: () {
                            setState(() {
                              _selectedCategory = 'College Project';
                            });
                            print('Technology Chip tapped!');
                          },
                          width: 140,
                          height: 30,
                        ),
                        FilterChipWidget(
                          label: 'Personal Development',
                          selectedCategory: _selectedCategory,
                          onTap: () {
                            setState(() {
                              _selectedCategory = 'Personal Development';
                            });
                            print('Politics Chip tapped!');
                          },
                          width: 160,
                          height: 30,
                        ),
                        FilterChipWidget(
                          label: 'Coding Club',
                          selectedCategory: _selectedCategory,
                          onTap: () {
                            setState(() {
                              _selectedCategory = 'Coding Club';
                            });
                            print('Politics Chip tapped!');
                          },
                          width: 120,
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  color: Color(0xFF211B2E),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25,top: 5,right: 10),
                    child: Icon(
                      CupertinoIcons.tags_solid,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      JobCard(
                        subject: 'Android Development',
                        postedTime: '2 hours ago',
                        description: 'Looking for an experienced Android developer for a mobile app project.',
                        priceRange: 'Rs. 100 - 200',
                        userName: 'naresh',
                      ),
                      JobCard(
                        subject: 'iOS Development',
                        postedTime: '3 hours ago',
                        description: 'iOS developer needed for a new app development project  mobile app project ...',
                        priceRange: 'Rs. 150 - 250',
                        userName: 'Vishnu',
                      ),
                      JobCard(
                        subject: 'iOS Development',
                        postedTime: '3 hours ago',
                        description: 'iOS developer needed for a new app development project.',
                        priceRange: 'Rs. 150 - 250',
                        userName: 'Avinash',
                      ),
                      JobCard(
                        subject: 'iOS Development',
                        postedTime: '3 hours ago',
                        description: 'iOS developer needed for a new app development project.',
                        priceRange: 'Rs. 150 - 250',
                        userName: 'Vishnu',
                      ),
                      JobCard(
                        subject: 'iOS Development',
                        postedTime: '3 hours ago',
                        description: 'iOS developer needed for a new app development project.',
                        priceRange: 'Rs. 150 - 250',
                        userName: 'Avinash',
                      ),
                      JobCard(
                        subject: 'iOS Development',
                        postedTime: '3 hours ago',
                        description: 'iOS developer needed for a new app development project.',
                        priceRange: 'Rs. 150 - 250',
                        userName: 'Vishnu',
                      ),
                      JobCard(
                        subject: 'iOS Development',
                        postedTime: '3 hours ago',
                        description: 'iOS developer needed for a new app development project.',
                        priceRange: 'Rs. 150 - 250',
                        userName: 'Avinash',
                      ),

                    ],
                  ),
                ),
              ),
            ),

            // Bottom banner ad
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60, // Adjust the height of the ad container as needed
                  decoration: BoxDecoration(
                    color: Colors.grey, // Change the background color of the ad container
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'Ad',
                      style: TextStyle(color: Colors.grey.shade50,fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),

            // this the code to filter through chip
            // Expanded(
            //   flex: 1,
            //   child: ListView.builder(
            //     itemCount: selectedCategoryNews.length,
            //     itemBuilder: (context, index) {
            //       return Padding(
            //         padding: const EdgeInsets.only(top: 25,left: 25,right: 25),
            //         child: ListTile(
            //           title: Text(selectedCategoryNews[index],style: TextStyle(color: Colors.white),),
            //         ),
            //       );
            //     },
            //   ),
            // ),

            // to select category

          ],
        ),
      ),
    );
  }
}
