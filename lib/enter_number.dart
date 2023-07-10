import 'dart:math';

import 'package:flutter/material.dart';
import 'package:school_app/api_repository.dart';
import 'package:school_app/custom_app_bar.dart';
import 'package:school_app/dashboard.dart';
import 'package:school_app/input_decorations.dart';
import 'package:school_app/my_theme.dart';
import 'package:school_app/scan_code.dart';
import 'package:school_app/student_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnterNumber extends StatefulWidget {
  const EnterNumber({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<EnterNumber> createState() => _EnterNumberState();
}

class _EnterNumberState extends State<EnterNumber> {
  final numberController = TextEditingController();
  BuildContext? loadingContext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(screenWidth, 60),
            child: const CustomAppBar('Enter Student Number', Icons.person)),
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
              Center(
                child: submitButton(context),
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
            buildDescription('Enter Student Number',
                description: 'Please go ahead and scan the student cards'),
            creditForm(),
          ],
        ),
      ),
    );
  }

  Container submitButton(BuildContext context) {
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
            'Submit',
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
          ),
          onPressed: () {
            onSubmit(numberController.text);
          }),
    );
  }

  onSubmit(studentNumber) async {
    loading();
    var studentResponse =
        await ApiRepository().getStudentResponse(studentNumber);
    Navigator.of(loadingContext!).pop();
    if (studentResponse.message != null) {
      // ignore: use_build_context_synchronously
      showToast(context, studentResponse.message!);
      return;
    } else {
      // ignore: use_build_context_synchronously
      showToast(context, 'Scan Successful');
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return StudentDetails(
            studentResponse.username!,
            studentResponse.name!,
            studentResponse.studentClass!,
            studentResponse.studentSchool!,
            studentResponse.guardianName!,
            studentResponse.guardianPhoneNumber!);
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
              Text("Validating account..."),
            ],
          ));
        });
  }
}
