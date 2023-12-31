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
import 'package:school_app/students_on_trip_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TripDetails extends StatefulWidget {
  const TripDetails(
    this.tripId, {
    Key? key,
  }) : super(key: key);

  final int tripId;
  @override
  _TripDetailsState createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  BuildContext? loadingContext;
  String? driverUsername;
  List<Data>? students = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStudentsOnTrip(widget.tripId.toString());
  }

  getStudentsOnTrip(String id) async {
    var studentsOnTripResponse = await ApiRepository().studentsOnTrip(id);
    if (studentsOnTripResponse.data != null) {
      setState(() {
        students = studentsOnTripResponse.data;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(screenWidth, 60),
            child: const CustomAppBar('Trip Details', Icons.person)),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: buildBody(),
        ));
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          buildDescription('Student Details',
              description:
                  'Please make sure these are the correct students on the trip'),
          studentList(),
          Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter, child: endTrip(context)))
        ],
      ),
    );
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

  studentList() {
    if (isLoading) {
      return CircularProgressIndicator(
        color: MyTheme.accent_color,
      );
    } else {
      if (students!.length == 0) {
        return Text('No students found!');
      } else {
        return ListView.builder(
            itemCount: students!.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return CheckboxListTile(
                title: Text(students![index].studentUsername),
                secondary: Icon(
                  Icons.person,
                  color: Colors.red,
                ),
                value: students![index].checked,
                onChanged: (value) => setState(() {
                  students![index].checked = !students![index].checked;
                }),
                activeColor: Colors.red,
              );
            });
      }
    }
  }

  Container endTrip(BuildContext context) {
    return Container(
      height: 45,
      child: FlatButton(
          minWidth: MediaQuery.of(context).size.width / 1.09,
          disabledColor: MyTheme.grey_153,
          //height: 50,
          color: Colors.red,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          child: const Text(
            'End Trip',
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
          ),
          onPressed: () async {
            await closeTrip(widget.tripId.toString());
            // ignore: use_build_context_synchronously
          }),
    );
  }

  closeTrip(String id) async {
    // List<Data>? _selectedStudents =
    //     students!.where((student) => student.checked).toList();
    // print(_selectedStudents);

    var createTripResponse = await ApiRepository().closeTrip(id);
    if (createTripResponse.message == null) {
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return DashboardPage(title: 'Dashboard');
      }));
    } else {
      // ignore: use_build_context_synchronously
      showToast(context, createTripResponse.message!);
      // ignore: use_build_context_synchronously
    }
  }
}
