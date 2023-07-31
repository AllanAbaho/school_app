// To parse this JSON data, do
//
//     final StudentsOnTripResponse = StudentsOnTripResponseFromJson(jsonString);

import 'dart:convert';

StudentsOnTripResponse studentsOnTripResponseFromJson(String str) =>
    StudentsOnTripResponse.fromJson(json.decode(str));

String studentsOnTripResponseToJson(StudentsOnTripResponse data) =>
    json.encode(data.toJson());

class StudentsOnTripResponse {
  StudentsOnTripResponse({this.data});

  final List<Data>? data;

  factory StudentsOnTripResponse.fromJson(List<dynamic> json) =>
      StudentsOnTripResponse(
          data: List<Data>.from(json.map((x) => Data.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Data {
  Data(this.studentUsername, this.id, this.checked);

  final String studentUsername;
  final int id;
  bool checked;

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(json["studentUsername"], json["id"], true);

  Map<String, dynamic> toJson() => {
        "studentUsername": studentUsername,
        "id": id,
      };
}
