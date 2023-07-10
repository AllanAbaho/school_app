// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse(
      {this.id,
      this.username,
      this.name,
      this.email,
      this.phoneNumber,
      this.schoolName,
      this.userType,
      this.message,
      this.roles});

  final String? username,
      name,
      email,
      phoneNumber,
      schoolName,
      userType,
      message;
  final int? id;
  final List<Role>? roles;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        id: json["id"],
        username: json["username"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        schoolName: json["schoolName"],
        userType: json["userType"],
        message: json["message"],
        roles: json["roles"] != null
            ? List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "schoolName": schoolName,
        "userType": userType,
        "message": message,
        "roles": List<dynamic>.from(roles!.map((x) => x.toJson())),
      };
}

class Role {
  Role(this.role, this.note);

  final String role;
  final String note;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        json["role"],
        json["note"],
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "note": note,
      };
}
