import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizedo/components/CustomRichText.dart';
import 'package:wizedo/components/white_text.dart';
import '../components/FliterChip.dart';
import '../components/JobCard.dart';
import 'detailsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  final searchFilter = TextEditingController();
  String searchTerm = '';
  String _selectedCategory = 'College Project';
  String userCollegee = 'null';
  final _debouncer = Debouncer(delay: Duration(milliseconds: 1500));
  DocumentSnapshot<Map<String, dynamic>>? _lastDocument;
  final ScrollController _scrollController = ScrollController();
  bool isFirstRun = true;
  final RxBool isLoading = true.obs;
  bool isLoadingMore = false;

  final RxMap<String, List<DocumentSnapshot<Map<String, dynamic>>>> _categoryDocuments =
      <String, List<DocumentSnapshot<Map<String, dynamic>>>>{}.obs;


  Future<String?> getUserEmailLocally() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userEmail = prefs.getString('userEmail');
      return userEmail;
    } catch (error) {
      print('Error fetching user email locally: $error');
      return null;
    }
  }

  Future<String?> getSelectedCollegeLocally(String userEmail) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("after this statement select college locally should show");
      print(prefs.getString('selectedCollege_$userEmail'));
      return prefs.getString('selectedCollege_$userEmail');
    } catch (error) {
      print('Error getting selected college locally: $error');
      return null;
    }
  }

  Future<void> getUserCollege() async {
    try {
      String? email = await getUserEmailLocally();
      String? userCollege = await getSelectedCollegeLocally(email!);
      setState(() {
        userCollegee = userCollege ?? 'null set manually2';
        print('User College in homepage: $userCollegee');
      });
    } catch (error) {
      print('Error getting user college: $error');
    }
  }

  String cleanUpUserName(String email) {
    String userName = email.split('@')[0];
    userName = userName.replaceAll(RegExp(r'[^\w\s]'), '');
    userName = userName.replaceAll(RegExp(r'\d'), '');
    return userName;
  }

  @override
  void initState() {
    super.initState();
    getUserCollege();
    print('below is height we got using getx');
    print(Get.height);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          isLoadingMore = true;
        fetchMoreDocuments(_selectedCategory);
      }
    });

  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> buildDocumentStream(String postId) {
    print('$postId post is updated');
    return FirebaseFirestore.instance
        .collection('colleges')
        .doc(userCollegee)
        .collection('collegePosts')
        .doc(postId)
        .snapshots();
  }

  Widget buildPostWidget(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    var data = documentSnapshot.data() as Map<String, dynamic>;

    // Check if the post's status is not equal to "active"
    if (data['status'] != 'active') {
      return Container();
    }

    Timestamp date = data['createdAt'];
    var finalDate = DateTime.parse(date.toDate().toString());

    String lowerCaseDescription = data['description'].toLowerCase();
    bool containsSearchTerm = searchTerm.isEmpty ||
        lowerCaseDescription.contains(searchTerm.toLowerCase());

    if (containsSearchTerm) {
      return GestureDetector(
        onTap: () {
          print(data);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(
                category: data['category'],
                subject: data['subCategory'],
                date: data['createdAt'],
                description: data['description'],
                priceRange: data['totalPayment'],
                finalDate: data['dueDate'],
                postid: data['postId'],
                emailid: data['emailid'],
              ),
            ),
          );
        },
        child: JobCard(
          category: _selectedCategory,
          subject: data['subCategory'],
          date: data['createdAt'],
          description: data['description'],
          priceRange: data['totalPayment'],
          userName: cleanUpUserName(data['emailid']),
          finalDate: finalDate,
        ),
      );
    } else {
      return Container();
    }
  }

  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> buildStreamBuilder(String postId) {
    print('Building stream for post ID: $postId');
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: buildDocumentStream(postId),
      builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return CircularProgressIndicator();
        // } else
          if (snapshot.hasError) {
          return WhiteText('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Container(); // Or any placeholder widget
        } else {
          return buildPostWidget(snapshot.data!);
        }
      },
    );
  }

  Widget buildListViewForCategory(String category) {
    print('building list view category for $category');
    if (_categoryDocuments[category] == null || _categoryDocuments[category]!.isEmpty) {
      return Center(child: WhiteText('No data available'));
    } else {
      return Obx(() => ListView.builder(
        controller: _scrollController,
        itemCount: _categoryDocuments[category]!.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (index == _categoryDocuments[category]!.length) {
            // If the index is equal to the number of existing items,
            // show the loading indicator
            return Center(child: CircularProgressIndicator());
          } else {
            var data = _categoryDocuments[category]![index].data() as Map<String, dynamic>;

            // Check if the current index is within the last 3 indices
            if (index >= _categoryDocuments[category]!.length - 4) {
              return buildStreamBuilder(data['postId']);
            } else {
              // Return buildPostWidget for other indices
              return buildPostWidget(_categoryDocuments[category]![index]);
            }
          }
        },
      ));
    }
  }


  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> buildStreamBuilderForCategory(String category) {
    print('Building stream for category: $category');
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('colleges')
          .doc(userCollegee)
          .collection('collegePosts')
          .where('category', isEqualTo: category)
          .where('status', isEqualTo: 'active')
          .limit(4)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: WhiteText('Error: ${snapshot.error}'));
        } else {
          if (_categoryDocuments[category] == null) {
            print('Initially it was null, so if statement');
            _categoryDocuments[category] = snapshot.data!.docs;
            _lastDocument = _categoryDocuments[category]!.last;
          }
          print('Data received. Number of documents: ${snapshot.data!.docs.length}');
          print('Below is item count');
          print(_categoryDocuments[category]!.length);

          return buildListViewForCategory(category);
        }
      },
    );

  }




  Future<void> fetchMoreDocuments(String category) async {
    try {
      QuerySnapshot<Map<String, dynamic>> newSnapshot = await FirebaseFirestore.instance
          .collection('colleges')
          .doc(userCollegee)
          .collection('collegePosts')
          .where('category', isEqualTo: category)
          .where('status', isEqualTo: 'active')
          .limit(3)
          .startAfterDocument((_categoryDocuments[category]?.last ?? _lastDocument) as DocumentSnapshot<Object?>)
          .get();

      if (newSnapshot.docs.isNotEmpty) {
        int numberOfNewDocuments = newSnapshot.docs.length;
        print('$numberOfNewDocuments new documents fetched');

        // Use RxList method to update the observable list
        _categoryDocuments[category]?.addAll(newSnapshot.docs);
        _lastDocument = newSnapshot.docs.last;

        // Notify the UI that data has changed
        _categoryDocuments.refresh();
        print(_categoryDocuments[category]);
        print('below is new snapshot fetched');
        print(newSnapshot.docs);
      } else {
        print('No more documents');
      }
    } catch (error) {
      print('Error fetching more documents: $error');
    } finally {
      // Notify the UI that loading has finished
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF211B2E),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () async {
                              print('Fetch more tapped');
                              isLoading.value = true;
                              await fetchMoreDocuments(_selectedCategory);
                            },
                            child: CustomRichText(
                              firstText: 'Peer',
                              secondText: 'mate',
                              firstColor: Colors.white,
                              secondColor: Color(0xFF955AF2),
                              firstFontSize: 20,
                              secondFontSize: 20,
                            ),
                          ),
                          WhiteText('Learn Together, Achieve Together', fontSize: 9,),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded, color: Colors.white, size: 20),
                              SizedBox(width: 2),
                              WhiteText(
                                userCollegee.length <= 45
                                    ? userCollegee
                                    : userCollegee.substring(0, 45) + '...',
                                fontSize: 9,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
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
                                            if (_auth.currentUser != null) {
                                              String userEmail = _auth.currentUser!.email ?? "No email available";
                                              Get.snackbar('Current User', 'Email: $userEmail');
                                            } else {
                                              Get.snackbar('Error', 'No user signed in');
                                            }
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
            Container(
              height: 45,
              width: Get.width * 0.9,
              margin: const EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 15),
              child: TextFormField(
                controller: searchFilter,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF39304D).withOpacity(0.9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onChanged: (String value) {
                  _debouncer(() {
                    setState(() {
                      searchTerm = value;
                    });
                  });
                },
              ),
            ),
            Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, left: 50),
                    child: Row(
                      children: [
                        FilterChipWidget(
                          label: 'College Project',
                          selectedCategory: _selectedCategory,
                          onTap: () async {
                            if (_selectedCategory != 'College Project') {
                              setState(() {
                                _selectedCategory = 'College Project';
                              });
                            }
                            print('College Chip tapped!');
                          },
                          width: 140,
                          height: 30,
                        ),
                        FilterChipWidget(
                          label: 'Personal Development',
                          selectedCategory: _selectedCategory,
                          onTap: () async {
                            if (_selectedCategory != 'Personal Development') {
                              setState(() {
                                _selectedCategory = 'Personal Development';
                              });
                            }
                            print('Personal Chip tapped!');
                          },
                          width: 160,
                          height: 30,
                        ),
                        FilterChipWidget(
                          label: 'Assignment',
                          selectedCategory: _selectedCategory,
                          onTap: () async {
                            if (_selectedCategory != 'Assignment') {
                              setState(() {
                                _selectedCategory = 'Assignment';
                              });
                            }
                            print('Assignment Chip tapped!');
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
                    padding: const EdgeInsets.only(left: 25, top: 5, right: 10),
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
                child: buildStreamBuilderForCategory(_selectedCategory),
              ),
            ),
          ],
        ),
      ),
    );
  }
}