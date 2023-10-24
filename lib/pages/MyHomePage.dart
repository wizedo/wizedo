// import 'package:flutter/material.dart';
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   String _selectedCategory = 'Technology';
//   List<String> _technologyNews = ['Tech News 1', 'Tech News 2', 'Tech News 3'];
//   List<String> _politicsNews = ['Politics News 1', 'Politics News 2', 'Politics News 3'];
//   List<String> _scienceNews = ['Science News 1', 'Science News 2', 'Science News 3'];
//
//   @override
//   Widget build(BuildContext context) {
//     List<String> selectedCategoryNews;
//     if (_selectedCategory == 'Technology') {
//       selectedCategoryNews = _technologyNews;
//     } else if (_selectedCategory == 'Politics') {
//       selectedCategoryNews = _politicsNews;
//     } else {
//       selectedCategoryNews = _scienceNews;
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('News App'),
//       ),
//       body: Column(
//         children: [
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 FilterChipWidget('Technology', _selectedCategory, () {
//                   setState(() {
//                     _selectedCategory = 'Technology';
//                   });
//                 }),
//                 FilterChipWidget('Politics', _selectedCategory, () {
//                   setState(() {
//                     _selectedCategory = 'Politics';
//                   });
//                 }),
//                 FilterChipWidget('Science', _selectedCategory, () {
//                   setState(() {
//                     _selectedCategory = 'Science';
//                   });
//                 }),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: selectedCategoryNews.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(selectedCategoryNews[index]),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class FilterChipWidget extends StatelessWidget {
//   final String label;
//   final String selectedCategory;
//   final Function onTap;
//
//   FilterChipWidget(this.label, this.selectedCategory, this.onTap);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: FilterChip(
//         label: Text(label),
//         selected: selectedCategory == label,
//         onSelected: (isSelected) {
//           if (isSelected) {
//             onTap();
//           }
//         },
//         selectedColor: Color(0xFF955AF2),
//         backgroundColor: Color(0xFF39304D),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30.0),
//         ),
//       ),
//     );
//   }
// }

//how to use

// FilterChipWidget('Technology', _selectedCategory, () {
// setState(() {
// _selectedCategory = 'Technology';
// });
// }),