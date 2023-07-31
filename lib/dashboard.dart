import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:school_app/api_repository.dart';
import 'package:school_app/app_colors.dart';
import 'package:school_app/custom_app_bar.dart';
import 'package:school_app/enter_number.dart';
import 'package:school_app/input_decorations.dart';
import 'package:school_app/login_response.dart';
import 'package:school_app/my_theme.dart';
import 'package:school_app/scan_code.dart';
import 'package:school_app/statistics_response.dart';
import 'package:school_app/trip_details.dart';
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

  List<Stat> stats = [];
  String driverStatus = 'NOT_STARTED';
  int? tripId;

  BuildContext? loadingContext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterNativeSplash.remove();

    getPrefs();
  }

  getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('name')!;
      schoolController.text = prefs.getString('school')!;
      numberController.text = prefs.getString('phoneNumber')!;
    });
    getStatistics();
    checkDriverStatus();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(screenWidth, 60),
          child: CustomAppBar(schoolController.text, Icons.person)),
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

  getStatistics() async {
    var statsResponse =
        await ApiRepository().getStatistics(numberController.text);
    setState(() {
      stats = statsResponse.stats!;
    });
  }

  createTrip(String tripType) async {
    loading();

    var createTripResponse =
        await ApiRepository().createTrip(numberController.text, tripType);
    Navigator.of(loadingContext!).pop();
    if (createTripResponse.message != null) {
      // ignore: use_build_context_synchronously
      showToast(context, createTripResponse.message!);
      return;
    } else {
      // ignore: use_build_context_synchronously
      showToast(context, 'Trip created successfully!');
      setState(() {
        driverStatus = createTripResponse.tripStatus!;
        tripId = createTripResponse.id!;
      });
    }
  }

  checkDriverStatus() async {
    var createTripResponse =
        await ApiRepository().checkDriverStatus(numberController.text);
    if (createTripResponse.message == null) {
      setState(() {
        driverStatus = createTripResponse.tripStatus!;
        print(driverStatus);
        tripId = createTripResponse.id!;
      });
      checkTripStatus(tripId.toString());
    } else {
      // ignore: use_build_context_synchronously
      showToast(context, createTripResponse.message!);
    }
  }

  checkTripStatus(String id) async {
    var createTripResponse = await ApiRepository().checkTripStatus(id);

    if (createTripResponse.message == null) {
    } else {
      // ignore: use_build_context_synchronously
      showToast(context, createTripResponse.message!);
    }
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

  _chooseTripTypeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Container(
          height: 100,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Choose Trip Type',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const Divider(
                color: Color.fromRGBO(133, 186, 51, 1),
              ),
              Column(
                children: [
                  Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Flexible(
                        child: Text(
                          'Please choose one of the options below?',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          await createTrip('PICK_UP');
                        },
                        child: const Text(
                          'PICK UP',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 20,
                        color: Colors.black,
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          await createTrip('DROP_OFF');
                        },
                        child: const Text(
                          'DROP OFF',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(133, 186, 51, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            profilePage(),
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
          color: Colors.blue,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          child: const Text(
            'Scan Code',
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ScanCode('Scan Code', tripId!);
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
              return EnterNumber(
                title: 'Enter Number',
                tripId: tripId!,
              );
            }));
          }),
    );
  }

  Container startTrip(BuildContext context) {
    return Container(
      height: 45,
      child: FlatButton(
          minWidth: MediaQuery.of(context).size.width / 1.09,
          disabledColor: MyTheme.grey_153,
          //height: 50,
          color: Colors.green,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          child: const Text(
            'Start Trip',
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
          ),
          onPressed: () {
            _chooseTripTypeDialog();
          }),
    );
  }

  Container setUpTrip(BuildContext context) {
    return Container(
      height: 45,
      child: FlatButton(
          minWidth: MediaQuery.of(context).size.width / 1.09,
          disabledColor: MyTheme.grey_153,
          //height: 50,
          color: Colors.green,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          child: const Text(
            'Create Trip',
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
          ),
          onPressed: () {
            _chooseTripTypeDialog();
          }),
    );
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
            'View Trip',
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
          ),
          onPressed: () async {
            // await closeTrip(tripId.toString());
            // ignore: use_build_context_synchronously
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TripDetails(tripId!);
            }));
          }),
    );
  }

  Widget profilePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(1000)),
          child: CachedNetworkImage(
            imageUrl:
                'https://img.freepik.com/free-vector/gradient-high-school-logo-design_23-2149626932.jpg',
            fit: BoxFit.cover,
            height: 150,
            width: 150,
            placeholder: (context, url) => CircularProgressIndicator(
              color: MyTheme.accent_color,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            nameController.text,
            style: TextStyle(
              fontSize: 25,
              color: MyTheme.accent_color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            numberController.text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: stats.isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: stats
                      .map(
                        (stat) => statistics(
                            stat.dateCount, stat.role.replaceAll('_', ' ')),
                      )
                      .toList(),
                )
              : CircularProgressIndicator(
                  color: MyTheme.accent_color,
                ),
        ),
        Visibility(
          visible: driverStatus == 'IN_PROGRESS' || driverStatus == 'OPEN',
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                scanButton(context),
                manualButton(context),
              ],
            ),
          ),
        ),
        Visibility(
          visible: driverStatus == 'NOT_STARTED' || driverStatus == 'ENDED',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              setUpTrip(context),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Visibility(
          visible: driverStatus == 'IN_PROGRESS' || driverStatus == 'OPEN',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              endTrip(context),
            ],
          ),
        )
      ],
    );
  }

  Widget statistics(int amount, String metric) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            '$amount',
            style: TextStyle(
              fontSize: 20,
              // color: MyTheme.accent_color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            metric,
            style: TextStyle(
              // color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
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
}
