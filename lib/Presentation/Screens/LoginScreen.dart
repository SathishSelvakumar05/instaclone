import 'package:alab/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../CommonFunctions/HelperFunction.dart';
import '../../CommonFunctions/LocalNotification.dart';
import '../../LocalStorage/CRUD/User_CRUD.dart';
import '../../LocalStorage/Models/UserModel.dart';
import '../Widgets/CustomButton.dart';
import '../Widgets/CustomTextField.dart';
import 'HomeScreen.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final GlobalKey<FormFieldState> _mobileFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _otpFieldKey = GlobalKey<FormFieldState>();
  String MobileNumber = "";
  String Otp = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 246, 1),
      body: Padding(
        padding: const EdgeInsets.all(18.0).r,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 90.h),

            // Logo
            Center(
              child: Container(
                height: 68.h,
                width: 73.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF3A7BD5), Color(0xFF8E2DE2)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 7),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.white,
                    size: 32.sp,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            Text(
              "Welcome Back!",
              style: TextStyle(
                color: Colors.black,
                fontSize: 27,
                letterSpacing: 2,
              ),
            ),

            SizedBox(height: 6.h),

            Text(
              "Login to your account",
              style: TextStyle(color: Colors.blueGrey, fontSize: 17),
            ),

            SizedBox(height: 15.h),
            CustomTextField(
              fieldKey: _mobileFieldKey,
              placeHolder: "Enter 10-digit number",
              name: "mobile",
              keyBoardType: TextInputType.number,
              labelName: "Mobile Number",
              onChanged: (val) {
                setState(() {
                  MobileNumber = val!;
                });
              },
              labelIcon: Icon(Icons.mobile_friendly),
              validators: [(val) => CommonFunctions().validateMobile(val)],
            ),

            // SEND OTP BUTTON
            CustomElevatedButton(
              text: "Send OTP",
              ButtonColor: Colors.blue,
              width: double.infinity,
              height: 35.h,
              onPressed: () async {
                if (_mobileFieldKey.currentState!.validate()) {
                  String otp = CommonFunctions().generateOtp();

                  await LocalNotification.showInstantNotification(
                    title: "One Time OTP",
                    body: "Your OTP is $otp",
                  );
                  Fluttertoast.showToast(msg: "OTP Sent Successfully");
                }
              },
            ),

            SizedBox(height: 15.h),

            // OTP FIELD
            CustomTextField(
              fieldKey: _otpFieldKey,
              placeHolder: "6-digit OTP",
              name: "otp",
              keyBoardType: TextInputType.number,
              labelName: "Enter OTP",
              onChanged: (val) {
                setState(() {
                  Otp = val!;
                });
              },

              labelIcon: Icon(Icons.lock),
              validators: [(val) => CommonFunctions().validateOtp(val)],
            ),

            // LOGIN BUTTON
            CustomElevatedButton(
              text: "Login",
              ButtonColor: Colors.blue,
              width: double.infinity,
              height: 35.h,
              onPressed: () async {
                if (_mobileFieldKey.currentState!.validate() &&
                    _otpFieldKey.currentState!.validate()) {
                  Fluttertoast.showToast(msg: "Login Successfully");
                  await User().insertUser(
                    userModel(mobileNumber: MobileNumber, Otp: Otp),
                    localDB,
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => DashboardScreen(),
                    ),
                  );
                }
              },
            ),

            SizedBox(height: 15.h),
          ],
        ),
      ),
    );
  }
}
