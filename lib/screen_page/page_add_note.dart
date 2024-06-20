import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_note/model/model_add_notes.dart';
import 'package:project_note/screen_page/page_utama.dart'; // Import halaman PageUtama

class PageAddNotes extends StatefulWidget {
  const PageAddNotes({super.key});

  @override
  State<PageAddNotes> createState() => _PageAddNotesState();
}

class _PageAddNotesState extends State<PageAddNotes> {
  TextEditingController txtJudul = TextEditingController();
  TextEditingController txtIsi = TextEditingController();

  //validasi form
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  //Proses untuk hit API
  bool isLoading = false;

  Future<ModelAddNotes?> addNotes() async {
    //handle error
    try {
      setState(() {
        isLoading = true;
      });

      http.Response response = await http.post(
        Uri.parse('http://192.168.43.45/notes/addNote.php'),
        body: {
          "judul": txtJudul.text,
          "isi": txtIsi.text,
        },
      );

      ModelAddNotes data = modelAddNotesFromJson(response.body);
      //Cek kondisi
      if (data.value == 1) {
        //Kondisi ketika berhasil register
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data.message}')),
          );

          // Navigasi ke halaman utama setelah sukses
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PageUtama()),
          );
        });
      } else if (data.value == 2) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data.message}')),
          );
        });
      } else {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data.message}')),
          );
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Catatan Baru'),
      ),
      body: Form(
        key: keyForm,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  //validasi kosong
                  validator: (val) {
                    return val!.isEmpty ? "Tidak boleh kosong" : null;
                  },
                  controller: txtJudul,
                  decoration: InputDecoration(
                    hintText: 'Judul',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  //validasi kosong
                  validator: (val) {
                    return val!.isEmpty ? "Tidak boleh kosong" : null;
                  },
                  controller: txtIsi,
                  maxLines: null, // Memungkinkan untuk multiline
                  decoration: InputDecoration(
                    hintText: 'Isi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                //Proses cek loading
                Center(
                  child: isLoading
                      ? Center(
                    child: CircularProgressIndicator(),
                  )
                      : MaterialButton(
                    minWidth: 150,
                    height: 45,
                    onPressed: () {
                      //Cek validasi form ada kosong atau tidak
                      if (keyForm.currentState?.validate() == true) {
                        setState(() {
                          addNotes();
                        });
                      }
                    },
                    child: Text('Add'),
                    color: Colors.green,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        width: 1,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
