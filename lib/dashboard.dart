import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_app/app_colors.dart';
import 'package:school_app/custom_app_bar.dart';
import 'package:school_app/enter_number.dart';
import 'package:school_app/input_decorations.dart';
import 'package:school_app/login_response.dart';
import 'package:school_app/my_theme.dart';
import 'package:school_app/scan_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _counter = 0;
  final nameController = TextEditingController();
  final schoolController = TextEditingController();
  final numberController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
  }

  getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    nameController.text = prefs.getString('name')!;
    schoolController.text = prefs.getString('school')!;
    numberController.text = prefs.getString('phoneNumber')!;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(screenWidth, 60),
          child: const CustomAppBar('Dashboard', Icons.person)),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: "Click to logout",
          backgroundColor: MyTheme.accent_color,
          child: const Icon(Icons.exit_to_app),
          onPressed: () async {
            _showLogOutDialog();
          }),
    );
  }

  _showLogOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Container(
          width: 200,
          height: 100,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Divider(
                color: Color.fromRGBO(133, 186, 51, 1),
              ),
              Column(
                children: [
                  Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Flexible(
                        child: Text(
                          'Are you sure you want to log out?',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            color: MyTheme.accent_color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 20,
                          color: Colors.black,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            prefs.clear();
                            SystemNavigator.pop();
                          },
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(133, 186, 51, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget creditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Account Number',
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
                        readOnly: true,
                        keyboardType: TextInputType.number,
                        controller: numberController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            icon: Icons.abc),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Account Name',
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
                        readOnly: true,
                        keyboardType: TextInputType.phone,
                        controller: nameController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            icon: Icons.numbers),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'School Name',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 55.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 36,
                      child: TextField(
                        readOnly: true,
                        keyboardType: TextInputType.number,
                        controller: schoolController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            icon: Icons.numbers),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    scanButton(context),
                    manualButton(context),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildDescription('Dashboard',
                description: 'Please go ahead and scan the student cards'),
            creditForm(),
          ],
        ),
      ),
    );
  }

  Container scanButton(BuildContext context) {
    return Container(
      height: 45,
      child: FlatButton(
          minWidth: MediaQuery.of(context).size.width / 2.5,
          disabledColor: MyTheme.grey_153,
          //height: 50,
          color: MyTheme.accent_color,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          child: const Text(
            'Scan Code',
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const ScanCode('Scan Code');
            }));
          }),
    );
  }

  Container manualButton(BuildContext context) {
    return Container(
      height: 45,
      child: FlatButton(
          minWidth: MediaQuery.of(context).size.width / 2.5,
          disabledColor: MyTheme.grey_153,
          //height: 50,
          color: MyTheme.dark_font_grey,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          child: const Text(
            'Enter Number',
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const EnterNumber(
                title: 'Enter Number',
              );
            }));
          }),
    );
  }
}
