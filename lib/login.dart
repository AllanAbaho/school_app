// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:school_app/app_colors.dart';
import 'package:school_app/api_repository.dart';
import 'package:school_app/custom_app_bar.dart';
import 'package:school_app/dashboard.dart';
import 'package:school_app/input_decorations.dart';
import 'package:school_app/login_response.dart';
import 'package:school_app/my_theme.dart';
import 'package:school_app/verify_otp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneController = TextEditingController();
  final pinController = TextEditingController();
  BuildContext? loadingContext;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: MyTheme.accent_color,
                      fontSize: 30,
                      height: 2,
                      fontWeight: FontWeight.w300),
                ),
              ),
              Center(
                child: Text(
                  'Enter your phone and pin to login',
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 14,
                      height: 2,
                      fontWeight: FontWeight.w300),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Center(
                child: Image(
                  image: AssetImage('assets/login.jpg'),
                  height: 350,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Phone',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 36,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: phoneController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "0700460055", icon: Icons.phone),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'PIN',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 36,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: pinController,
                        obscureText: true,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "********", icon: Icons.pin),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  height: 45,
                  child: FlatButton(
                      minWidth: MediaQuery.of(context).size.width,
                      disabledColor: MyTheme.grey_153,
                      //height: 50,
                      color: MyTheme.accent_color,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6.0))),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      ),
                      onPressed: () {
                        onSubmit();
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const DashboardPage()));
                      }),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  onSubmit() async {
    var phone = phoneController.text.toString();
    var pin = pinController.text.toString();
    if (phone == "") {
      showToast(context, 'Please enter your phone number');
      return;
    } else if (pin == "") {
      showToast(context, 'Please enter your pin');
      return;
    }
    loading();

    var loginResponse = await ApiRepository().getLoginResponse(phone, pin);
    Navigator.of(loadingContext!).pop();
    if (loginResponse.message != null) {
      showToast(context, loginResponse.message!);
      return;
    } else {
      List<Role> roles = loginResponse.roles!;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('name', loginResponse.name!);
      prefs.setString('school', loginResponse.schoolName!);
      prefs.setString('phoneNumber', loginResponse.phoneNumber!);
      prefs.setString('userType', loginResponse.userType!);
      prefs.setString('roles', jsonEncode(roles));

      showToast(context, 'Login Successful');
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return DashboardPage(title: loginResponse.schoolName!);
      }));
    }

    // Navigator.push(context,
    //     MaterialPageRoute(builder: (context) => VerifyOTP('1234', phone)));
  }

  loading() {
    showDialog(
        context: context,
        builder: (context) {
          loadingContext = context;
          return AlertDialog(
              content: Row(
            children: [
              CircularProgressIndicator(color: MyTheme.accent_color),
              const SizedBox(
                width: 10,
              ),
              const Text(
                "Logging in...",
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ));
        });
  }
}
