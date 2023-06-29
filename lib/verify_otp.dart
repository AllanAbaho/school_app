import 'package:flutter/material.dart';
import 'package:school_app/app_colors.dart';
import 'package:school_app/custom_app_bar.dart';
import 'package:school_app/dashboard.dart';
import 'package:school_app/input_decorations.dart';
import 'package:school_app/my_theme.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP(this.otp, this.phone, {Key? key}) : super(key: key);
  final String otp, phone;
  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  final otpController = TextEditingController();
  @override
  void initState() {
    super.initState();
    print(widget.otp);
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
                height: 40,
              ),
              Center(
                child: Text(
                  'Verify Account',
                  style: TextStyle(
                      color: AppColors.dashboardColor,
                      fontSize: 30,
                      height: 1,
                      fontWeight: FontWeight.w300),
                ),
              ),
              Center(
                child: Text(
                  'Enter 4-digit code we have sent to your number',
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 14,
                      height: 1.6,
                      fontWeight: FontWeight.w300),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Center(
                child: Image(
                  image: AssetImage('assets/otp.jpg'),
                  height: 300,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Enter Code',
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
                        controller: otpController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "123456", icon: Icons.pin),
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
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0))),
                      child: const Text(
                        'Verify Now',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      ),
                      onPressed: () {
                        if (otpController.text != widget.otp) {
                          showToast(context, 'Please enter the correct OTP');
                          return;
                        } else {
                          showToast(context, 'Login Successful');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DashboardPage(title: 'Dashboard')));
                        }
                      }),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Haven\'t received the code yet?',
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 14,
                      height: 1.6,
                      fontWeight: FontWeight.w300),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Container(
                  height: 45,
                  child: FlatButton(
                      minWidth: MediaQuery.of(context).size.width,
                      disabledColor: MyTheme.grey_153,
                      //height: 50,
                      color: MyTheme.font_grey,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6.0))),
                      child: Text(
                        'Resend Code',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      ),
                      onPressed: () {
                        // onSubmit();
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const RegisterPage()));
                      }),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
