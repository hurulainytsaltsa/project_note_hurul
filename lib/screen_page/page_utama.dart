import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_note/model/model_notes.dart';
import 'package:project_note/screen_page/page_add_note.dart';
import 'package:project_note/screen_page/page_detail_note.dart';
import 'package:project_note/screen_page/page_edit_note.dart';

class PageUtama extends StatefulWidget {
  const PageUtama({Key? key}) : super(key: key);

  @override
  State<PageUtama> createState() => _PageUtamaState();
}

class _PageUtamaState extends State<PageUtama> {
  TextEditingController searchController = TextEditingController();
  List<Datum>? noteList;
  List<Datum>? filteredNoteList;

  // Method untuk get note
  Future<List<Datum>?> getNote() async {
    try {
      var response = await http.get(Uri.parse('http://192.168.43.45/notes/getNotes.php'));
      return modelNotesFromJson(response.body).data;
    } catch (e) {
      print('Error getNote: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      return null;
    }
  }

  // Method untuk menghapus catatan
  Future<void> deleteData(String id) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.43.45/notes/deleteNotes.php'),
        body: {'id': id},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['is_success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Catatan berhasil dihapus')),
          );
          setState(() {
            filteredNoteList = filteredNoteList?.where((note) => note.id != id).toList();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menghapus data: ${jsonResponse['message']}'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghubungi server'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Notes')),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  filteredNoteList = noteList
                      ?.where((element) =>
                  element.judul.toLowerCase().contains(value.toLowerCase()) ||
                      element.isi.toLowerCase().contains(value.toLowerCase()))
                      .toList();
                });
              },
              decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Datum>?>(
              future: getNote(),
              builder: (BuildContext context, AsyncSnapshot<List<Datum>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  );
                } else if (snapshot.hasData) {
                  noteList = snapshot.data;
                  if (filteredNoteList == null) {
                    filteredNoteList = noteList;
                  }
                  return ListView.builder(
                    itemCount: filteredNoteList!.length,
                    itemBuilder: (context, index) {
                      Datum data = filteredNoteList![index];
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            // Navigasi ke halaman detail
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PageDetailNotes(
                                  judul: data.judul,
                                  isi: data.isi,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(
                                    '${data.judul}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${data.isi}",
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.visibility),
                                        onPressed: () {
                                          // Handle detail view
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => PageDetailNotes(
                                                judul: data.judul,
                                                isi: data.isi,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PageEditNotes(data: data),
                                            ),
                                          ).then((updatedData) {
                                            if (updatedData != null) {
                                              setState(() {
                                                int dataIndex = filteredNoteList!.indexWhere((notes) => notes.id == updatedData.id);
                                                if (dataIndex != -1) {
                                                  filteredNoteList![dataIndex] = updatedData;
                                                }
                                              });
                                            }
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Hapus Data'),
                                              content: Text(
                                                'Apakah Anda yakin ingin menghapus data ini?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    deleteData(data.id.toString()); // Panggil fungsi deleteData dengan id
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Ya'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate ke PageAddNotes
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PageAddNotes()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan,
      ),
    );
  }
}
