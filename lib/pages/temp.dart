// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wizedo/components/CustomRichText.dart';
// import 'package:wizedo/components/white_text.dart';
// import 'package:wizedo/pages/privacyPolicy.dart';
// import '../components/CustomFilterChip.dart';
// import '../components/JobCard.dart';
// import '../components/my_elevatedbutton.dart';
// import 'detailsPage.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage>  {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   TextEditingController emailController = TextEditingController();
//   final searchFilter = TextEditingController();
//   String searchTerm = '';
//   String _selectedCategory = 'College Project';
//   String userCollegee = 'null';
//   final _debouncer = Debouncer(delay: const Duration(milliseconds: 1500));
//   DocumentSnapshot<Map<String, dynamic>>? _lastDocument;
//   final ScrollController _scrollController = ScrollController();
//   bool isFirstRun = true;
//   final RxBool isLoading = true.obs;
//   final RxBool alldocumentsfetched = false.obs;
//   final RxBool isLoadingMore = false.obs;
//   final FocusNode _searchFocusNode = FocusNode();
//   int searchResultsCount = 0;
//   List<String> searchedPostIds = [];
//   RxInt postsOpenedCount = 0.obs;
//
//   List<String> categories = [
//     'College Project',
//     'Personal Development',
//     'Assignment',
//   ];
//
//
//
//
//
//
//   final RxMap<String, List<DocumentSnapshot<Map<String, dynamic>>>> _categoryDocuments =
//       <String, List<DocumentSnapshot<Map<String, dynamic>>>>{}.obs;
//
//   final Map<String, List<DocumentSnapshot<Map<String, dynamic>>>> _tempDocuments = {};
//
//   Future<String?> getUserEmailLocally() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? userEmail = prefs.getString('userEmail');
//       return userEmail;
//     } catch (error) {
//       print('Error fetching user email locally: $error');
//       return null;
//     }
//   }
//
//   Future<String?> getSelectedCollegeLocally(String userEmail) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       print("after this statement select college locally should show");
//       print(prefs.getString('selectedCollege_$userEmail'));
//       return prefs.getString('selectedCollege_$userEmail');
//     } catch (error) {
//       print('Error getting selected college locally: $error');
//       return null;
//     }
//   }
//
//   Future<void> getUserCollege() async {
//     try {
//       String? email = await getUserEmailLocally();
//       String? userCollege = await getSelectedCollegeLocally(email!);
//       setState(() {
//         userCollegee = userCollege ?? 'null set manually2';
//         print('User College in homepage: $userCollegee');
//       });
//     } catch (error) {
//       print('Error getting user college: $error');
//     }
//   }
//
//   // String cleanUpUserName(String email) {
//   //   String userName = email.split('@')[0];
//   //   userName = userName.replaceAll(RegExp(r'[^\w\s]'), '');
//   //   userName = userName.replaceAll(RegExp(r'\d'), '');
//   //   return userName;
//   // }
//
//   @override
//   void initState() {
//     super.initState();
//     getUserCollege();
//     adloaded();
//     print('below is height we got using getx');
//     print(Get.height);
//
//
//
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
//         isLoadingMore.value = true;
//         fetchMoreDocuments(_selectedCategory);
//       }
//     });
//
//   }
//
//   Stream<DocumentSnapshot<Map<String, dynamic>>> buildDocumentStream(String postId) {
//     print('$postId post is updated');
//     return FirebaseFirestore.instance
//         .collection('colleges')
//         .doc(userCollegee)
//         .collection('collegePosts')
//         .doc(postId)
//         .snapshots();
//   }
//
//   final RxBool isIntersitalLoaded = false.obs;
//   late InterstitialAd interstitialAd;
//
//   adloaded() async{
//     InterstitialAd.load(
//         adUnitId: 'ca-app-pub-1022421175188483/1986580376',
//         request: const AdRequest(),
//         adLoadCallback: InterstitialAdLoadCallback(
//             onAdLoaded: (ad){
//               setState(() {
//                 interstitialAd=ad;
//                 isIntersitalLoaded.value=true;
//               });
//             },
//             onAdFailedToLoad: (error){
//               print(error);
//               interstitialAd.dispose();
//               isIntersitalLoaded.value=false;
//             }
//         )
//     );
//   }
//
//
//
//   Widget buildPostWidget(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
//     var data = documentSnapshot.data();
//     if (data == null || data.isEmpty) {
//       return Container();
//     }
//
//     // Check if the post's status is not equal to "active"
//     if (data['status'] != 'active') {
//       return Container();
//     }
//
//     Timestamp date = data['createdAt'];
//     var finalDate = DateTime.parse(date.toDate().toString());
//
//     String lowerCaseDescription = data['description'].toLowerCase();
//     bool containsSearchTerm = searchTerm.isEmpty ||
//         lowerCaseDescription.contains(searchTerm.toLowerCase());
//
//     if (containsSearchTerm) {
//       return GestureDetector(
//         onTap: () {
//           if (postsOpenedCount.value > 4) {
//             // Check if the interstitial ad is loaded
//             if (isIntersitalLoaded.value == true) {
//               // Show the interstitial ad
//               interstitialAd.show();
//               postsOpenedCount.value = 0;
//               // Dispose after showing ad
//               interstitialAd.dispose();
//               // Load a new ad for future use
//               adloaded();
//             } else {
//               print('Interstitial ad not loaded');
//             }
//           }
//           postsOpenedCount.value++;
//           print(data);
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => DetailsScreen(
//                 category: data['category'],
//                 subject: data['subCategory'],
//                 date: data['createdAt'],
//                 description: data['description'],
//                 priceRange: data['totalPayment'],
//                 finalDate: data['dueDate'],
//                 postid: data['postId'],
//                 googledrivelink: data['googledrivelink'],
//                 emailid: data['emailid'],
//                 college: data['college'],
//               ),
//             ),
//           );
//         },
//         child: JobCard(
//           category: _selectedCategory,
//           subject: data['subCategory'],
//           date: data['createdAt'],
//           description: data['description'],
//           priceRange: data['totalPayment'],
//           userName: data['firstname'],
//           finalDate: finalDate,
//         ),
//       );
//     } else {
//       return Container();
//     }
//   }
//
//
//   Future<void> fetchDocumentsBySearch(String category, String searchTerm) async {
//     try {
//       QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
//           .collection('colleges')
//           .doc(userCollegee)
//           .collection('collegePosts')
//           .where('category', isEqualTo: category)
//           .where('status', isEqualTo: 'active')
//           .where('description', isGreaterThanOrEqualTo: searchTerm)
//           .where('description', isLessThanOrEqualTo: '$searchTerm\uf8ff')
//           .get();
//
//       // Create a new list and add elements from _categoryDocuments[category]
//       _tempDocuments[category] = List.from(_categoryDocuments[category]!);
//       print('below is temp documents');
//       print(_tempDocuments[category]);
//
//       // Store the fetched post IDs in the list
//       List<String> newPostIds = snapshot.docs.map((doc) => doc['postId'] as String).toList();
//
//       // Print the number of posts/documents fetched
//       print('Number of documents fetched: ${newPostIds.length}');
//
//       // Add each postId to the searchPostIds list individually
//       for (String postId in newPostIds) {
//         searchedPostIds.add(postId);
//       }
//
//       _categoryDocuments[category]?.addAll(snapshot.docs);
//
//       // Print the length of _categoryDocuments for the specific category
//       print('Length of _categoryDocuments[$category]: ${_categoryDocuments[category]?.length}');
//
//       print(_categoryDocuments[category]);
//       print('below is again end temp documents');
//       print(_tempDocuments[category]);
//
//     } catch (error) {
//       print('Error fetching documents by search: $error');
//     } finally {
//       // Set isLoadingMore to false to prevent fetching more documents
//       isLoadingMore.value = false;
//     }
//   }
//
//
//
//   // Map to store streams for each post ID
//   final Map<String, StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>> _postSubscriptions = {};
//
//   StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> subscribeToStream(String postId) {
//     // Check if a subscription for the post ID already exists
//     if (_postSubscriptions.containsKey(postId)) {
//       return _postSubscriptions[postId]!;
//     } else {
//       // If not, create a new subscription and store it in the map
//       StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> newSubscription =
//       getOrCreateStream(postId).listen((snapshot) {
//         // Handle snapshot updates here
//       });
//       _postSubscriptions[postId] = newSubscription;
//       return newSubscription;
//     }
//   }
//
//   final Map<String, Stream<DocumentSnapshot<Map<String, dynamic>>>> _postStreams = {};
//
//   Stream<DocumentSnapshot<Map<String, dynamic>>> getOrCreateStream(String postId) {
//     // Check if the stream for the post ID already exists
//     if (_postStreams.containsKey(postId)) {
//       return _postStreams[postId]!;
//     } else {
//       // If not, create a new stream and store it in the map
//       Stream<DocumentSnapshot<Map<String, dynamic>>> newStream = buildDocumentStream(postId);
//       _postStreams[postId] = newStream;
//       return newStream;
//     }
//   }
//
//   @override
//   void dispose() {
//     print('widget and streams disposed');
//     // Dispose all the subscriptions when the widget is disposed
//     for (var subscription in _postSubscriptions.values) {
//       subscription.cancel();
//     }
//     super.dispose();
//   }
//
//   // Map to store whether all documents are fetched for each category
//   final RxMap<String, bool> alldocumentsfetchedMap = {
//     'College Project': false,
//     'Personal Development': false,
//     'Assignment': false,
//   }.obs;
//
//
//   // Function to fetch more documents for a specific category
//   Future<void> fetchMoreDocuments(String category) async {
//     try {
//       QuerySnapshot<Map<String, dynamic>> newSnapshot = await FirebaseFirestore.instance
//           .collection('colleges')
//           .doc(userCollegee)
//           .collection('collegePosts')
//           .where('category', isEqualTo: category)
//           .where('status', isEqualTo: 'active')
//           .limit(3)
//           .startAfterDocument((_categoryDocuments[category]?.last ?? _lastDocument) as DocumentSnapshot<Object?>)
//           .get();
//
//       if (newSnapshot.docs.isNotEmpty) {
//         // Update alldocumentsfetchedMap value
//         alldocumentsfetchedMap[category] = false;
//
//         // Use RxList method to update the observable list
//         _categoryDocuments[category]?.addAll(newSnapshot.docs);
//         _lastDocument = newSnapshot.docs.last;
//
//         // Notify the UI that data has changed
//         _categoryDocuments.refresh();
//         print(_categoryDocuments[category]);
//       } else {
//         // If no more documents are fetched, set alldocumentsfetched flag to true for the respective category
//         alldocumentsfetchedMap[category] = true;
//         print('No more documents for category: $category');
//
//         Get.showSnackbar(
//           GetSnackBar(
//             borderRadius: 8,
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             animationDuration: const Duration(milliseconds: 800),
//             duration: const Duration(milliseconds: 4000),
//             margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             snackPosition: SnackPosition.BOTTOM,
//             isDismissible: true,
//             backgroundColor: Colors.red.shade400,
//             // Set your desired color here
//             messageText: const WhiteText(
//               'Bottom reached. No more posts.',
//               fontSize: 12,
//             ),
//           ),
//         );
//
//
//       }
//     } catch (error) {
//       print('Error fetching more documents for category $category: $error');
//     } finally {
//       // Notify the UI that loading has finished
//       isLoading.value = false;
//     }
//   }
//
//   // Future<void> _handleRefresh() async{
//   //   await Future.delayed(Duration(seconds: 5));
//   //   setState(() {
//   //     print('page refreshed');
//   //   });
//   // }
//
//
//
//   // Widget to build the "Load More" button for each category
//   Widget buildLoadMoreButton(String category) {
//     return searchFilter.text.isEmpty ? // Check if the search filter is empty
//     Padding(
//       padding: const EdgeInsets.only(right: 15, top: 10, bottom: 20),
//       child: Align(
//         alignment: Alignment.bottomRight,
//         child: !alldocumentsfetchedMap[category]! ? MyElevatedButton(
//           width: 120,
//           height: 35,
//           mfontsize: 12,
//           borderRadius: 10,
//           melevation: 100,
//           onPressed: () {
//             // Load more documents when clicked
//             isLoadingMore.value = true;
//             fetchMoreDocuments(category);
//           },
//           buttonText: isLoadingMore.value && alldocumentsfetchedMap[category]! ? 'Loading...'.obs.value : 'Load More'.obs.value,
//         ) : Container(),
//       ),
//     )
//         : Container(); // Return an empty container if the search filter is not empty
//   }
//
//
//
//   StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> buildStreamBuilder(String postId) {
//     print('Building stream for post ID but not fetching or creating stream: $postId');
//     return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//       stream: getOrCreateStream(postId),
//       builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
//         // if (snapshot.connectionState == ConnectionState.waiting) {
//         //   return CircularProgressIndicator();
//         // } else
//         if (snapshot.hasError) {
//           return WhiteText('Error: ${snapshot.error}');
//         } else if (!snapshot.hasData || snapshot.data == null) {
//           return Container(); // Or any placeholder widget
//         } else {
//           return buildPostWidget(snapshot.data!);
//         }
//       },
//     );
//   }
//
//   // Update buildListViewForCategory to include the "Load More" button for each category
//   Widget buildListViewForCategory(String category) {
//     print('building list view category for $category');
//     if (_categoryDocuments[category] == null || _categoryDocuments[category]!.isEmpty) {
//       return const Center(child: WhiteText('No active posts'));
//     } else {
//       // Check if the initially fetched posts are less than or equal to 4
//       if (_categoryDocuments[category]!.length <= 4) {
//         // If so, don't show the "Load More" button
//         return Obx(() => RefreshIndicator(
//           onRefresh: () async {
//             await Future.delayed(const Duration(seconds: 5));
//             fetchMoreDocuments(category);
//             _categoryDocuments.refresh();
//           },
//           color: Colors.white,
//           backgroundColor: const Color(0xFF955AF2),
//           child: ListView.builder(
//             itemCount: _categoryDocuments[category]!.length,
//             itemBuilder: (BuildContext context, int index) {
//               var data = _categoryDocuments[category]![index].data() as Map<String, dynamic>;
//               return buildStreamBuilder(data['postId']);
//             },
//           ),
//         ));
//       } else {
//         // If there are more than 4 initially fetched posts, show the "Load More" button
//         return Obx(() => RefreshIndicator(
//           onRefresh: () async {
//             await Future.delayed(const Duration(seconds: 5));
//             fetchMoreDocuments(category);
//             _categoryDocuments.refresh();
//           },
//           color: Colors.white,
//           backgroundColor: const Color(0xFF955AF2),
//           child: ListView.builder(
//             itemCount: _categoryDocuments[category]!.length + 1,
//             itemBuilder: (BuildContext context, int index) {
//               if (index < _categoryDocuments[category]!.length) {
//                 var data = _categoryDocuments[category]![index].data() as Map<String, dynamic>;
//                 return buildStreamBuilder(data['postId']);
//               } else {
//                 // Render the "Load More" button
//                 return buildLoadMoreButton(category);
//               }
//             },
//           ),
//         ));
//       }
//     }
//   }
//
//
//
//
//
//
//   StreamBuilder<QuerySnapshot<Map<String, dynamic>>> buildStreamBuilderForCategory(String category) {
//     print('Building stream for category: $category');
//     return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//       stream: FirebaseFirestore.instance
//           .collection('colleges')
//           .doc(userCollegee)
//           .collection('collegePosts')
//           .where('category', isEqualTo: category)
//           .where('status', isEqualTo: 'active')
//       // .orderBy('createdAt', descending: false)
//           .limit(5)
//           .snapshots(),
//       builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: WhiteText('Error: ${snapshot.error}'));
//         } else {
//           if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
//             if (_categoryDocuments[category] == null) {
//               print('Initially it was null, so if statement');
//               _categoryDocuments[category] = snapshot.data!.docs;
//               _lastDocument = _categoryDocuments[category]!.last;
//             }
//             print('Data received. Number of documents: ${snapshot.data!.docs.length}');
//             print('Below is item count');
//             print(_categoryDocuments[category]!.length);
//             return buildListViewForCategory(category);
//           } else {
//             return const Center(child: WhiteText('No posts found from your college.'));
//           }
//         }
//       },
//     );
//   }
//
//   // Method to show the popover
//   void _showCategoryPopover(BuildContext context) {
//     showCupertinoModalPopup(
//       context: context,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10.0), // Adjust padding as needed
//           child: CupertinoActionSheet(
//             actions: [
//               CupertinoActionSheetAction(
//                 onPressed: () {
//                   setState(() {
//                     _selectedCategory = 'College Project';
//                     searchTerm = ''; // Reset search term
//                     searchFilter.clear(); // Clear search filter text field
//                   });
//                   Navigator.pop(context); // Close the popover
//                 },
//                 child: const Text('College Project'),
//               ),
//               CupertinoActionSheetAction(
//                 onPressed: () {
//                   setState(() {
//                     _selectedCategory = 'Personal Development';
//                     searchTerm = ''; // Reset search term
//                     searchFilter.clear(); // Clear search filter text field
//                   });
//                   Navigator.pop(context); // Close the popover
//                 },
//                 child: const Text('Personal Development'),
//               ),
//               CupertinoActionSheetAction(
//                 onPressed: () {
//                   setState(() {
//                     _selectedCategory = 'Assignment';
//                     searchTerm = ''; // Reset search term
//                     searchFilter.clear(); // Clear search filter text field
//                   });
//                   Navigator.pop(context); // Close the popover
//                 },
//                 child: const Text('Assignment'),
//               ),
//             ],
//             cancelButton: CupertinoActionSheetAction(
//               onPressed: () {
//                 Navigator.pop(context); // Close the popover
//               },
//               isDefaultAction: true,
//               child: const Text('Cancel'),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF211B2E),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 20, top: 10),
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         InkWell(
//                           onTap: () async {
//                             print('Fetch more tapped');
//                             print(postsOpenedCount);
//                             // isLoading.value = true;
//                             // await fetchMoreDocuments(_selectedCategory);
//                           },
//                           child: const CustomRichText(
//                             firstText: 'Peer',
//                             secondText: 'mate',
//                             firstColor: Colors.white,
//                             secondColor: Color(0xFF955AF2),
//                             firstFontSize: 20,
//                             secondFontSize: 20,
//                           ),
//                         ),
//                         const WhiteText(
//                           'Learn Together, Achieve Together',
//                           fontSize: 9,
//                         ),
//                         const SizedBox(height: 2),
//                         Row(
//                           children: [
//                             const Icon(Icons.location_on_rounded, color: Colors.white, size: 20),
//                             const SizedBox(width: 2),
//                             InkWell(
//                               onTap: () {
//                                 print('refresh');
//                                 _categoryDocuments.refresh();
//                                 print('Searched Post IDs for College Project: $searchedPostIds');
//                                 print('belwo is number of fetched search resulsts');
//                                 print(searchResultsCount);
//                               },
//                               child: WhiteText(
//                                 userCollegee.length <= 45
//                                     ? userCollegee
//                                     : '${userCollegee.substring(0, 45)}...',
//                                 fontSize: 9,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 5, right: 10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Container(
//                           width: 52.0,
//                           height: 52.0,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Center(
//                             child: Container(
//                               width: 46.0,
//                               height: 46.0,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: const Color(0xFF955AF2).withOpacity(0.1),
//                               ),
//                               child: Center(
//                                 child: Container(
//                                   width: 36.0,
//                                   height: 36.0,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: const Color(0xFF955AF2).withOpacity(0.1),
//                                   ),
//                                   child: Center(
//                                     child: Container(
//                                       width: 26,
//                                       height: 26,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(5),
//                                         color: const Color(0xFF39304D).withOpacity(0.9),
//                                       ),
//                                       child: FloatingActionButton(
//                                         backgroundColor: Colors.transparent,
//                                         onPressed: () {
//                                           if (_auth.currentUser != null) {
//                                             String userEmail = _auth.currentUser!.email ?? "No email available";
//                                             // Get.snackbar('Current User', 'Email: $userEmail');
//                                             Get.snackbar('Notifications', "You have no notifications at this time.");
//                                           } else {
//                                             Get.snackbar('Error', 'No user signed in');
//                                           }
//                                           print('Redirected to Post Page');
//                                         },
//                                         tooltip: 'Increment',
//                                         child: const Icon(Icons.notifications_on_rounded, color: Colors.white, size: 15.0),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               height: 45,
//               width: Get.width * 0.9,
//               margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//               child: TextFormField(
//                 focusNode: _searchFocusNode,
//                 controller: searchFilter,
//                 style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 12),
//                 decoration: InputDecoration(
//                   hintText: 'Search',
//                   hintStyle: const TextStyle(color: Colors.grey),
//                   filled: true,
//                   fillColor: const Color(0xFF39304D).withOpacity(0.9),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(15),
//                     borderSide: BorderSide.none,
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                   suffixIcon: searchFilter.text.isNotEmpty
//                       ? IconButton(
//                     icon: const Icon(Icons.clear_rounded, color: Colors.grey),
//                     onPressed: () {
//                       // Clear the search field
//                       searchFilter.clear();
//                       setState(() {
//                         // Reset the search term
//                         searchTerm = '';
//
//                         _categoryDocuments[_selectedCategory] = List.from(_tempDocuments[_selectedCategory]!);
//
//                         // Clear the list of searched post IDs
//                         searchedPostIds.clear();
//
//                         // Notify the UI that data has changed
//                         _categoryDocuments.refresh();
//                       });
//                     },
//                   )
//                       : IconButton(
//                     icon: const Icon(Icons.search, color: Colors.grey),
//                     onPressed: () {
//                       // Move focus to the TextFormField when search button is pressed
//                       FocusScope.of(context).requestFocus(_searchFocusNode);
//                       // Perform search or any other action when the search icon is pressed
//                       // You can customize this part based on your requirements
//                     },
//                   ),
//                 ),
//                 onChanged: (String value) {
//                   _debouncer(() async {
//                     setState(() {
//                       searchTerm = value;
//                     });
//                     if (searchTerm.isNotEmpty) {
//                       await fetchDocumentsBySearch(_selectedCategory, searchTerm);
//                     } else if (searchTerm.isEmpty) {
//                       print('searchterm is empty');
//                       _categoryDocuments.refresh();
//                     }
//
//                     // Fetch more documents as before
//                     isLoading.value = true;
//                     await fetchMoreDocuments(_selectedCategory);
//                   });
//                 },
//               ),
//             ),
//             Stack(
//               children: [
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   controller: _scrollController,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 5, left: 50),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const SizedBox(width: 10), // Adjust spacing as needed
//                         CustomFilterChip(
//                           label: 'College Project',
//                           chipWidth: 130,
//                           isSelected: _selectedCategory == 'College Project',
//                           onSelected: (isSelected) {
//                             if (!isSelected) return; // If already selected, do nothing
//                             setState(() {
//                               _selectedCategory = 'College Project';
//                               searchTerm = ''; // Reset search term
//                               searchFilter.clear(); // Clear search filter text field
//                             });
//                             _scrollToCategory('College Project');
//                             print('College Chip tapped!');
//                           },
//                         ),
//                         const SizedBox(width: 18), // Adjust spacing as needed
//
//                         CustomFilterChip(
//                           label: 'Personal Development',
//                           chipWidth: 180,
//                           isSelected: _selectedCategory == 'Personal Development',
//                           onSelected: (isSelected) {
//                             if (!isSelected) return; // If already selected, do nothing
//                             setState(() {
//                               _selectedCategory = 'Personal Development';
//                               searchTerm = ''; // Reset search term
//                               searchFilter.clear(); // Clear search filter text field
//                             });
//                             _scrollToCategory('Personal Development');
//                             print('Personal Chip tapped!');
//                           },
//                         ),
//                         const SizedBox(width: 18), // Adjust spacing as needed
//
//                         CustomFilterChip(
//                           label: 'Assignment',
//                           isSelected: _selectedCategory == 'Assignment',
//                           onSelected: (isSelected) {
//                             if (!isSelected) return; // If already selected, do nothing
//                             setState(() {
//                               _selectedCategory = 'Assignment';
//                               searchTerm = ''; // Reset search term
//                               searchFilter.clear(); // Clear search filter text field
//                             });
//                             _scrollToCategory('Assignment');
//                             print('Assignment Chip tapped!');
//                           },
//                         ),
//                         const SizedBox(width: 18), // Adjust spacing as needed
//                       ],
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     _showCategoryPopover(context); // Show popover on tap
//                   },
//                   child: Container(
//                     height: 45,
//                     color: const Color(0xFF211B2E),
//                     child: const Padding(
//                       padding: EdgeInsets.only(left: 25, top: 5, right: 10),
//                       child: Icon(
//                         CupertinoIcons.tag_solid,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: GestureDetector(
//                 onHorizontalDragEnd: (DragEndDetails details) {
//                   if (details.primaryVelocity! > 0) {
//                     // Swiped from left to right
//                     _changeCategory(-1); // Move to previous category
//                   } else if (details.primaryVelocity! < 0) {
//                     // Swiped from right to left
//                     _changeCategory(1); // Move to next category
//                   }
//                 },
//                 child: buildStreamBuilderForCategory(_selectedCategory),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _scrollToCategory(String category) {
//     double offset = 0.0;
//     switch (category) {
//       case 'College Project':
//         offset = 160.0;
//         break;
//       case 'Personal Development':
//         offset = 160.0; // Adjust this value based on your layout
//         break;
//       case 'Assignment':
//         offset = 360.0; // Adjust this value based on your layout
//         break;
//     }
//     _scrollController.animateTo(
//       offset,
//       duration: Duration(milliseconds: 700),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   void _changeCategory(int direction) {
//     //this is to change the category on swipe
//     setState(() {
//       int index = categories.indexOf(_selectedCategory);
//       int newIndex = (index + direction) % categories.length;
//       if (newIndex < 0) {
//         newIndex = categories.length - 1;
//       }
//       _selectedCategory = categories[newIndex];
//     });
//   }
//
//
//
// }