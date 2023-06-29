import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:school_app/apis.dart';
import 'dart:convert';

import 'package:school_app/login_response.dart';
import 'package:school_app/send_notification.dart';
import 'package:school_app/student_response.dart';

class ApiRepository {
  Future<LoginResponse> getLoginResponse(String username, String pin) async {
    var postBody = jsonEncode({
      "username": username,
      "pin": pin,
    });

    Uri url = Uri.parse("$schoolAPI/login");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Basic ${base64.encode(utf8.encode('$apiUsername:$apiPassword'))}"
        },
        body: postBody);

    return loginResponseFromJson(response.body);
  }

  Future<StudentResponse> getStudentResponse(String studentNumber) async {
    Uri url = Uri.parse("$schoolAPI/student/$studentNumber");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Basic ${base64.encode(utf8.encode('$apiUsername:$apiPassword'))}"
      },
    );

    return studentResponseFromJson(response.body);
  }

  Future<NotificationResponse> sendNotificationResponse(String studentUsername,
      String studentStatus, String performedByUsername, String appRef) async {
    Uri url = Uri.parse("$schoolAPI/send/notification");
    var postBody = jsonEncode({
      "studentUsername": studentUsername,
      "studentStatus": studentStatus,
      "performedByUsername": performedByUsername,
      "appRef": appRef
    });

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Basic ${base64.encode(utf8.encode('$apiUsername:$apiPassword'))}"
        },
        body: postBody);

    return notificationResponseFromJson(response.body);
  }
}
