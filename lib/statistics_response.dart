// To parse this JSON data, do
//
//     final StatisticsResponse = StatisticsResponseFromJson(jsonString);

import 'dart:convert';

StatisticsResponse statisticsResponseFromJson(String str) =>
    StatisticsResponse.fromJson(json.decode(str));

String statisticsResponseToJson(StatisticsResponse data) =>
    json.encode(data.toJson());

class StatisticsResponse {
  StatisticsResponse({this.stats});

  final List<Stat>? stats;

  factory StatisticsResponse.fromJson(List<dynamic> json) => StatisticsResponse(
      stats: List<Stat>.from(json.map((x) => Stat.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "stats": List<dynamic>.from(stats!.map((x) => x.toJson())),
      };
}

class Stat {
  Stat(this.role, this.dateCount);

  final String role;
  final int dateCount;

  factory Stat.fromJson(Map<String, dynamic> json) => Stat(
        json["role"],
        json["dateCount"],
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "dateCount": dateCount,
      };
}
