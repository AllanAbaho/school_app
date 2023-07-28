// To parse this JSON data, do
//
//     final StudentResponse = StudentResponseFromJson(jsonString);

import 'dart:convert';

import 'package:school_app/login_response.dart';

TripResponse tripResponseFromJson(String str) =>
    TripResponse.fromJson(json.decode(str));

String tripResponseToJson(TripResponse data) => json.encode(data.toJson());

class TripResponse {
  TripResponse({this.id, this.tripStatus, this.message, this.roles});

  final int? id;
  final String? tripStatus, message;
  final List<String>? roles;

  factory TripResponse.fromJson(Map<String, dynamic> json) => TripResponse(
        id: json["id"],
        tripStatus: json["tripStatus"],
        message: json["message"],
        roles: json["roles"] != null ? List<String>.from(json["roles"]) : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tripStatus": tripStatus,
        "message": message,
      };
}
