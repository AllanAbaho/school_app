// To parse this JSON data, do
//
//     final SchoolImageResponse = SchoolImageResponseFromJson(jsonString);

import 'dart:convert';

SchoolImageResponse schoolImageResponseFromJson(String str) =>
    SchoolImageResponse.fromJson(json.decode(str));

String schoolImageResponseToJson(SchoolImageResponse data) =>
    json.encode(data.toJson());

class SchoolImageResponse {
  SchoolImageResponse({this.thumbnailUrl, this.fullUrl, this.message});

  final String? thumbnailUrl, fullUrl, message;

  factory SchoolImageResponse.fromJson(Map<String, dynamic> json) =>
      SchoolImageResponse(
        thumbnailUrl: json["thumbnailUrl"],
        fullUrl: json["fullUrl"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "thumbnailUrl": thumbnailUrl,
        "fullUrl": fullUrl,
        "message": message,
      };
}
