import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:school_app/apis.dart';
import 'dart:convert';

import 'package:school_app/login_response.dart';
import 'package:school_app/send_notification.dart';
import 'package:school_app/statistics_response.dart';
import 'package:school_app/student_response.dart';
import 'package:school_app/trip_response.dart';

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
    print(response.body);

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

  Future<NotificationResponse> sendNotificationResponse(
      int tripId,
      String studentUsername,
      String studentStatus,
      String performedByUsername,
      String appRef) async {
    Uri url = Uri.parse("$schoolAPI/send/driver/notification");
    var postBody = jsonEncode({
      "tripId": tripId,
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

  Future<StatisticsResponse> getStatistics(String studentUsername) async {
    Uri url = Uri.parse("$schoolAPI/events/username/$studentUsername");

    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization":
          "Basic ${base64.encode(utf8.encode('$apiUsername:$apiPassword'))}"
    });
    return statisticsResponseFromJson(response.body);
  }

  Future<TripResponse> createTrip(String username, tripType) async {
    Uri url = Uri.parse("$schoolAPI/trip");
    var postBody = jsonEncode(
        {"username": username, "tripType": tripType, "note": 'TESTING'});

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Basic ${base64.encode(utf8.encode('$apiUsername:$apiPassword'))}"
        },
        body: postBody);

    return tripResponseFromJson(response.body);
  }

  Future<TripResponse> checkTripStatus(String tripId) async {
    Uri url = Uri.parse("$schoolAPI/trip/$tripId");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Basic ${base64.encode(utf8.encode('$apiUsername:$apiPassword'))}"
      },
    );

    return tripResponseFromJson(response.body);
  }

  Future<TripResponse> closeTrip(String tripId) async {
    Uri url = Uri.parse("$schoolAPI/end/trip/$tripId");

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Basic ${base64.encode(utf8.encode('$apiUsername:$apiPassword'))}"
      },
    );

    return tripResponseFromJson(response.body);
  }

  Future<TripResponse> checkDriverStatus(String username) async {
    Uri url = Uri.parse("$schoolAPI/trip/driver/username/$username");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Basic ${base64.encode(utf8.encode('$apiUsername:$apiPassword'))}"
      },
    );

    return tripResponseFromJson(response.body);
  }
}
