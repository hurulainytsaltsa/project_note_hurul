// To parse this JSON data, do
//
//     final modelAddNotes = modelAddNotesFromJson(jsonString);


import 'dart:convert';

ModelAddNotes modelAddNotesFromJson(String str) => ModelAddNotes.fromJson(json.decode(str));

String modelAddNotesToJson(ModelAddNotes data) => json.encode(data.toJson());

class ModelAddNotes {
  int value;
  String message;

  ModelAddNotes({
    required this.value,
    required this.message,
  });

  factory ModelAddNotes.fromJson(Map<String, dynamic> json) => ModelAddNotes(
    value: json["value"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "message": message,
  };
}
