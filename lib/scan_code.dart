import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:school_app/api_repository.dart';
import 'package:school_app/custom_app_bar.dart';
import 'package:school_app/my_theme.dart';
import 'package:school_app/student_details.dart';

class ScanCode extends StatefulWidget {
  const ScanCode(this.title, this.tripId, {Key? key}) : super(key: key);

  final String title;
  final int tripId;

  @override
  _ScanCodeState createState() => _ScanCodeState();
}

class _ScanCodeState extends State<ScanCode> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _accountController = TextEditingController();
  TextEditingController _narrationController = TextEditingController();
  BuildContext? loadingContext;
  String? clientName = '';
  String? clientPhone = '';

  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

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
            child:
                CustomAppBar(widget.title, Icons.wallet_membership_outlined)),
        body: Padding(padding: const EdgeInsets.all(8.0), child: qrPage()));
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (result != null) {
          controller.stopCamera();
          print(result);
          onSubmit(result);
        }
      });
    });
    // controller.pauseCamera();
    controller.resumeCamera();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget qrPage() {
    return Column(
      children: <Widget>[
        Expanded(flex: 4, child: _buildQrView(context)),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: MediumText(
              'Scan Code',
              color: Colors.red,
            ),
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
            buildDescription(widget.title,
                description:
                    'Please enter the amount and phone number that you want to send money to.'),
            qrPage(),
          ],
        ),
      ),
    );
  }

  onSubmit(result) async {
    final studentNumber = result.code.split('-')[0];
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
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return StudentDetails(
            studentResponse.username!,
            studentResponse.name!,
            studentResponse.studentClass!,
            studentResponse.studentSchool!,
            studentResponse.guardianName!,
            studentResponse.guardianPhoneNumber!,
            widget.tripId);
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
