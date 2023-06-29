import 'package:flutter/material.dart';
import 'package:school_app/dashboard.dart';
import 'package:school_app/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await Future.delayed(const Duration(milliseconds: 300));

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final bool currentUser = false;
  bool loggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: loggedIn
          ? const DashboardPage(
              title: 'Dashboard',
            )
          : const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }

  checkIfLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('name')) {
      setState(() {
        loggedIn = true;
      });
    }
  }
}
