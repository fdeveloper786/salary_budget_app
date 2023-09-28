import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Presentation/Widgets/Screens/HomeScreen/home_screen.dart';
import 'package:salary_budget/Presentation/Widgets/Screens/Login/login_screen.dart';
import 'package:salary_budget/Presentation/Widgets/common_widgets/common_widgets.dart';
import 'package:salary_budget/repository/authenticaion_repository.dart';

class OTPController extends GetxController {
  static OTPController get instance => Get.find();

  // OTP Verification Method

  void otpVerification(String phoneNo, BuildContext context) async {
    bool? isVerified;
    try {
      isVerified = await AuthenticationRepository.instance.verifyOTP(phoneNo);
      print("----- is verified ---- $isVerified");
      if (isVerified != null) {
        WidgetsHelper.onLoadingPage(context);
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context); //pop dialog
          if (isVerified!) {
            setSession();
            Get.offAll(HomeScreen());
          } else {
            Get.to(() => LoginScreen());
          }
          //isVerified! ? Get.offAll(HomeScreen()) : Get.to(()=>LoginScreen());//Get.back();
        });
      } else {
        WidgetsHelper.onLoadingPage(context);
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context); //pop dialog
          Get.snackbar(errorLbl, somethingWentWrongWithOtpLbl);
          Get.to(() => LoginScreen());
        });
      }
    } on FirebaseAuthException catch (e) {
      print("Failed otp $e");
      // Get.snackbar('Error', 'Wrong OTP..');
    }
  }

  void setSession() async {
    await AuthenticationRepository.instance.setLoginSession();
  }
}
