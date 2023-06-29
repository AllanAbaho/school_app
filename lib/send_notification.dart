import 'dart:convert';

NotificationResponse notificationResponseFromJson(String str) =>
    NotificationResponse.fromJson(json.decode(str));

String notificationResponseToJson(NotificationResponse data) =>
    json.encode(data.toJson());

class NotificationResponse {
  NotificationResponse(
      {this.transactionStatus, this.studentStatus, this.appRef, this.message});

  final String? transactionStatus, studentStatus, appRef, message;
  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      NotificationResponse(
        transactionStatus: json["transactionStatus"],
        studentStatus: json["studentStatus"],
        appRef: json["appRef"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "transactionStatus": transactionStatus,
        "studentStatus": studentStatus,
        "appRef": appRef,
      };
}
