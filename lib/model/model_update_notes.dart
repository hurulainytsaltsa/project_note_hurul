// To parse this JSON data, do
//
//     final modelEditNotes = modelEditNotesFromJson(jsonString);

import 'dart:convert';

ModelEditNotes modelEditNotesFromJson(String str) => ModelEditNotes.fromJson(json.decode(str));

String modelEditNotesToJson(ModelEditNotes data) => json.encode(data.toJson());

class ModelEditNotes {
  bool isSuccess;
  int value;
  String message;

  ModelEditNotes({
    required this.isSuccess,
    required this.value,
    required this.message,
  });

  factory ModelEditNotes.fromJson(Map<String, dynamic> json) => ModelEditNotes(
    isSuccess: json["is_success"],
    value: json["value"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "value": value,
    "message": message,
  };
}
