// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:project11_notescrud/screen_page/page_update.dart';
//
// import '../model/model_notes.dart';
// // Sesuaikan dengan path yang benar untuk halaman PageInsertNote
//
// class PageNotes extends StatefulWidget {
//   @override
//   _PageNotesState createState() => _PageNotesState();
// }
//
// class _PageNotesState extends State<PageNotes> {
//   List<Datum> notesList = [];
//   List<Datum> filteredNotesList = [];
//   TextEditingController txtSearch = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchNotes();
//   }
//
//   Future<void> fetchNotes() async {
//     try {
//       final response = await http.get(
//           Uri.parse("http://192.168.43.124/notesDB/getNotes.php"));
//
//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         if (jsonResponse['isSuccess'] == true) {
//           setState(() {
//             ModelNotes modelNotes = ModelNotes.fromJson(jsonResponse);
//             notesList = modelNotes.data;
//             filteredNotesList = List<Datum>.from(notesList);
//           });
//         } else {
//           throw Exception('Failed to load notes: ${jsonResponse['message']}');
//         }
//       } else {
//         throw Exception('Failed to load notes: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Failed to load notes: $e');
//     }
//   }
//
//   void filterNotesList(String keyword) {
//     setState(() {
//       filteredNotesList = notesList
//           .where((note) =>
//       note.judulNote.toLowerCase().contains(keyword.toLowerCase()) ||
//           note.isiNote.toLowerCase().contains(keyword.toLowerCase()) ||
//           note.ket.toLowerCase().contains(keyword.toLowerCase()))
//           .toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'List Notes',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Color.fromRGBO(5, 25, 54, 1.0),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: TextField(
//               controller: txtSearch,
//               decoration: InputDecoration(
//                 hintText: 'Search Notes...',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onChanged: (value) {
//                 filterNotesList(value);
//               },
//             ),
//           ),
//           Expanded(
//             child: filteredNotesList.isEmpty
//                 ? Center(
//               child: Text('No Notes found'),
//             )
//                 : SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columns: <DataColumn>[
//                   DataColumn(
//                     label: Text(
//                       'Title',
//                       style: TextStyle(fontStyle: FontStyle.italic),
//                     ),
//                     tooltip: 'Title',
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'Description',
//                       style: TextStyle(fontStyle: FontStyle.italic),
//                     ),
//                     tooltip: 'Description',
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'Action',
//                       style: TextStyle(fontStyle: FontStyle.italic),
//                     ),
//                     tooltip: 'Action',
//                   ),
//                 ],
//                 rows: filteredNotesList
//                     .asMap()
//                     .entries
//                     .map(
//                       (entry) => DataRow(
//                     cells: [
//                       DataCell(Text(entry.value.judulNote)),
//                       DataCell(Text(entry.value.isiNote)),
//                       DataCell(
//                         Row(
//                           children: [
//                             IconButton(
//                               onPressed: () {
//                                 // Delete Note
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) => AlertDialog(
//                                     title: Text('Confirm Delete'),
//                                     content: Text(
//                                         'Are you sure you want to delete this note?'),
//                                     actions: <Widget>[
//                                       TextButton(
//                                         onPressed: () {
//                                           Navigator.of(context).pop(false); // Close dialog
//                                         },
//                                         child: Text('No'),
//                                       ),
//                                       TextButton(
//                                         onPressed: () {
//                                           // Send request to delete Note
//                                           http.post(
//                                             Uri.parse(
//                                                 'http://192.168.43.124/notesDB/deleteNote.php'),
//                                             body: {
//                                               'id': entry.value.id,
//                                             }, // Send Note ID to be deleted
//                                           ).then((response) {
//                                             // Check server response
//                                             if (response.statusCode ==
//                                                 200) {
//                                               var jsonResponse =
//                                               json.decode(
//                                                   response.body);
//                                               if (jsonResponse[
//                                               'isSuccess'] ==
//                                                   true) {
//                                                 // If deletion is successful, remove data from list
//                                                 setState(() {
//                                                   filteredNotesList
//                                                       .removeAt(
//                                                       entry.key);
//                                                 });
//                                               } else {
//                                                 // If deletion fails, show error message
//                                                 showDialog(
//                                                   context: context,
//                                                   builder:
//                                                       (context) {
//                                                     return AlertDialog(
//                                                       title: Text(
//                                                           "Success"),
//                                                       content: Text(
//                                                           "${jsonResponse['message']}"),
//                                                       actions: [
//                                                         TextButton(
//                                                           onPressed:
//                                                               () {
//                                                             Navigator
//                                                                 .pushAndRemoveUntil(
//                                                               context,
//                                                               MaterialPageRoute(
//                                                                   builder: (context) =>
//                                                                       PageNotes()),
//                                                                   (route) =>
//                                                               false, // Remove all pages in the navigation stack
//                                                             );
//                                                           },
//                                                           child: Text(
//                                                               "OK"),
//                                                         ),
//                                                       ],
//                                                     );
//                                                   },
//                                                 );
//                                               }
//                                             } else {
//                                               // If server response fails, show general error message
//                                               showDialog(
//                                                 context: context,
//                                                 builder: (context) {
//                                                   return AlertDialog(
//                                                     title:
//                                                     Text("Failed"),
//                                                     content: Text(
//                                                         "An error occurred while sending data to the server"),
//                                                     actions: [
//                                                       TextButton(
//                                                         onPressed:
//                                                             () {
//                                                           Navigator.pop(
//                                                               context);
//                                                         },
//                                                         child:
//                                                         Text("OK"),
//                                                       ),
//                                                     ],
//                                                   );
//                                                 },
//                                               );
//                                             }
//                                           }).catchError((error) {
//                                             // Handle connection or other errors
//                                             showDialog(
//                                               context: context,
//                                               builder: (context) {
//                                                 return AlertDialog(
//                                                   title:
//                                                   Text("Failed"),
//                                                   content: Text(
//                                                       "An error occurred: $error"),
//                                                   actions: [
//                                                     TextButton(
//                                                       onPressed: () {
//                                                         Navigator.pop(
//                                                             context);
//                                                       },
//                                                       child:
//                                                       Text("OK"),
//                                                     ),
//                                                   ],
//                                                 );
//                                               },
//                                             );
//                                           });
//                                           Navigator.of(context)
//                                               .pop(true); // Close dialog
//                                         },
//                                         child: Text('Yes'),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                               icon: Icon(Icons.delete),
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 // Edit Note
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         PageEditNote( data: entry.value),
//                                   ),
//                                 ).then((updatedNote) {
//                                   if (updatedNote != null) {
//                                     // Update existing Note data with the modified data
//                                     setState(() {
//                                       // Find the index of the updated Note data
//                                       int dataIndex =
//                                       filteredNotesList.indexWhere(
//                                               (note) =>
//                                           note.id ==
//                                               updatedNote.id);
//                                       if (dataIndex != -1) {
//                                         filteredNotesList[dataIndex] =
//                                             updatedNote;
//                                       }
//                                     });
//                                   }
//                                 });
//                               },
//                               icon: Icon(Icons.edit),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//                     .toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigator.push(
//           //   context,
//           //   MaterialPageRoute(builder: (context) => PageInsertNote()),
//           // );
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.blue,
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   }
// }dia tu langsung gini sya