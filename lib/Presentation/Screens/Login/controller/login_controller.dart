import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:salary_budget/Data/Core/Utils/navigator.dart';
import 'package:salary_budget/Presentation/Screens/HomeScreen/home_screen.dart';
import 'package:salary_budget/repository/authentication_repository.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final GoogleSignIn googleSignIn = GoogleSignIn();
  // TextField controller
  final mobileController = TextEditingController();
  var mobileNumber = ''.obs;
  var generatedOtp = ''.obs;
  var isOtpFieldVisible = false.obs;

  final otpController = TextEditingController();
  final mobileFocusNode = FocusNode();
  final otpFocusNode = FocusNode();

  void phoneAuthentication(String phoneNo) {
    AuthenticationRepository.instance.phoneAuthentication(phoneNo);
  }

  Future<bool?> checkGoogleSignInAuth() {
    return AuthenticationRepository.instance.checkGoogleLogin();
  }

  Future<User?> googleAuthentication() {
    return AuthenticationRepository.instance.handleGoogleSignIn();
  }

  Future<void> googleLogOut() {
    return AuthenticationRepository.instance.logoutGoogle();
  }

  void setSession([String? phoneNo]) async {
    await AuthenticationRepository.instance.setLoginSession(phoneNo!);
  }

  String generateOtp() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  void loginWithOTP() {
    String enteredOtp = otpController.text.trim();
    if (enteredOtp.isEmpty) {
      Get.snackbar("Error", "OTP cannot be empty");
    } else if (enteredOtp == generatedOtp.value) {
      Get.snackbar("Success", "Login successful!");
    } else {
      Get.snackbar("Error", "Invalid OTP");
    }
  }

  void validateField() {
    isOtpFieldVisible.value = true;
    otpController.text = generateOtp();
  }

  void navigateToScreen(BuildContext screenContext) {
    if(otpController.text.isNotEmpty) {
      print("mobile ${mobileController.text}");
      setSession(mobileController.text);
      AppNavigator.commonNavigator(screenContext, HomeScreen(userName: mobileController.text,));
      clearField();
    }
  }

  clearField() {
    mobileController.clear();
    otpController.clear();
  }

}
