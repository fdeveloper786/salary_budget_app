import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:salary_budget/repository/authenticaion_repository.dart';
import 'dart:developer' as developer;

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  // TextField controller
  final phoneController = TextEditingController();

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
}
