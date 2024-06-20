import 'dart:convert';

ModelDeleteNotes modelDeleteNotesFromJson(String str) => ModelDeleteNotes.fromJson(json.decode(str));

String modelDeleteNotesToJson(ModelDeleteNotes data) => json.encode(data.toJson());

class ModelDeleteNotes {
  bool isSuccess;
  int value;
  String message;

  ModelDeleteNotes({
    required this.isSuccess,
    required this.value,
    required this.message,
  });

  factory ModelDeleteNotes.fromJson(Map<String, dynamic> json) => ModelDeleteNotes(
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
