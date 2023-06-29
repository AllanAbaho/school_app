// To parse this JSON data, do
//
//     final StudentResponse = StudentResponseFromJson(jsonString);

import 'dart:convert';

StudentResponse studentResponseFromJson(String str) =>
    StudentResponse.fromJson(json.decode(str));

String studentResponseToJson(StudentResponse data) =>
    json.encode(data.toJson());

class StudentResponse {
  StudentResponse(
      {this.id,
      this.username,
      this.name,
      this.email,
      this.guardianName,
      this.guardianPhoneNumber,
      this.studentClass,
      this.studentSchool,
      this.message});

  final int? id;
  final String? username,
      name,
      email,
      guardianName,
      guardianPhoneNumber,
      studentClass,
      studentSchool,
      message;

  factory StudentResponse.fromJson(Map<String, dynamic> json) =>
      StudentResponse(
        id: json["id"],
        username: json["username"],
        name: json["name"],
        email: json["email"],
        guardianName: json["guardianName"],
        guardianPhoneNumber: json["guardianPhoneNumber"],
        studentClass: json["studentClass"],
        studentSchool: json["studentSchool"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "email": email,
        "guardianName": guardianName,
        "guardianPhoneNumber": guardianPhoneNumber,
        "studentClass": studentClass,
        "studentSchool": studentSchool,
        "message": message,
      };
}
