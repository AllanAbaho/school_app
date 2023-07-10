import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_app/api_repository.dart';
import 'package:school_app/custom_app_bar.dart';
import 'package:school_app/dashboard.dart';
import 'package:school_app/input_decorations.dart';
import 'package:school_app/login_response.dart';
import 'package:school_app/my_theme.dart';
import 'package:school_app/scan_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentDetails extends StatefulWidget {
  const StudentDetails(
    this.number,
    this.name,
    this.className,
    this.school,
    this.parentName,
    this.parentContact, {
    Key? key,
  }) : super(key: key);

  final String number, name, className, school, parentName, parentContact;
  @override
  _StudentDetailsState createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  final numberController = TextEditingController();
  final nameController = TextEditingController();
  final classNameController = TextEditingController();
  final schoolController = TextEditingController();
  final parentNameController = TextEditingController();
  final parentContactController = TextEditingController();
  BuildContext? loadingContext;
  String successStatus = '';
  Role? _selectedRole;
  List<Role> roles = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    numberController.text = widget.number;
    nameController.text = widget.name;
    classNameController.text = widget.className;
    schoolController.text = widget.school;
    parentNameController.text = widget.parentName;
    parentContactController.text = widget.parentContact;
    getRoles();
  }

  getRoles() async {
    final prefs = await SharedPreferences.getInstance();
    var encodedRoles = prefs.getString('roles');
    var decodedRoles = jsonDecode(encodedRoles!);
    setState(() {
      roles = List<Role>.from(decodedRoles.map((x) => Role.fromJson(x)));
      _selectedRole = roles[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(screenWidth, 60),
            child: const CustomAppBar('Student Details', Icons.person)),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: buildBody(),
        ));
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
                  'Student Number',
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
                  'Student Name',
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
                  'Class Name',
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
                        controller: classNameController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            icon: Icons.numbers),
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'Select Status',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
              ...roles.map(
                (role) => ListTile(
                  title: Text(role.role.replaceAll('_', ' ')),
                  leading: Radio(
                    activeColor: Colors.red,
                    value: role,
                    groupValue: _selectedRole,
                    onChanged: (Role? value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                  ),
                ),
              ),
              // ListTile(
              //   title: const Text('Pick Up'),
              //   leading: Radio(
              //     value: BestTutorSite.javatpoint,
              //     groupValue: _site,
              //     onChanged: (BestTutorSite? value) {
              //       setState(() {
              //         _site = value!;
              //       });
              //     },
              //   ),
              // ),
              // ListTile(
              //   title: const Text('Drop Off'),
              //   leading: Radio(
              //     value: BestTutorSite.w3schools,
              //     groupValue: _site,
              //     onChanged: (BestTutorSite? value) {
              //       setState(() {
              //         _site = value!;
              //       });
              //     },
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Container(
                      height: 45,
                      child: FlatButton(
                          minWidth: MediaQuery.of(context).size.width / 1.5,
                          disabledColor: MyTheme.grey_153,
                          //height: 50,
                          color: MyTheme.accent_color,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.0))),
                          child: const Text(
                            'Next ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w300),
                          ),
                          onPressed: () {
                            onSubmit();
                          }),
                    ),
                  ),
                ],
              ),
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
            buildDescription('Student Details',
                description: 'Please make sure these are the correct details'),
            creditForm(),
          ],
        ),
      ),
    );
  }

  onSubmit() async {
    final prefs = await SharedPreferences.getInstance();
    var rng = new Random();
    var code = rng.nextInt(900000) + 100000;
    var studentUsername = widget.number;
    var studentStatus = _selectedRole?.role;
    var performedByUsername = prefs.getString('phoneNumber')!;
    var appRef = code.toString();

    print(studentUsername);
    print(studentStatus);
    print(performedByUsername);
    print(appRef);
    loading();
    var studentResponse = await ApiRepository().sendNotificationResponse(
        studentUsername, studentStatus!, performedByUsername, appRef);
    Navigator.of(loadingContext!).pop();
    if (studentResponse.message != null) {
      // ignore: use_build_context_synchronously
      showToast(context, studentResponse.message!);
      return;
    } else {
      // ignore: use_build_context_synchronously
      showToast(context, 'Notification sent successfully');
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const DashboardPage(title: 'Dashboard');
      }));
    }
  }

  loading() {
    showDialog(
        context: context,
        builder: (context) {
          loadingContext = context;
          return AlertDialog(
              content: Row(
            children: [
              CircularProgressIndicator(
                color: MyTheme.accent_color,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Loading..."),
            ],
          ));
        });
  }

  void onBack() {
    Navigator.pop(context);
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    //   return ToWallet(
    //     'To Wallet',
    //   );
    // }));
  }
}

enum BestTutorSite { javatpoint, w3schools, tutorialandexample }
