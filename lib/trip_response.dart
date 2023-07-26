// To parse this JSON data, do
//
//     final StudentResponse = StudentResponseFromJson(jsonString);

import 'dart:convert';

TripResponse tripResponseFromJson(String str) =>
    TripResponse.fromJson(json.decode(str));

String tripResponseToJson(TripResponse data) => json.encode(data.toJson());

class TripResponse {
  TripResponse({this.id, this.tripStatus, this.message});

  final int? id;
  final String? tripStatus, message;

  factory TripResponse.fromJson(Map<String, dynamic> json) => TripResponse(
        id: json["id"],
        tripStatus: json["tripStatus"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tripStatus": tripStatus,
        "message": message,
      };
}
