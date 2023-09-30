import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:salary_budget/repository/authenticaion_repository.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  // TextField controller
  final phoneController = TextEditingController();

  void phoneAuthentication(String phoneNo) {
    AuthenticationRepository.instance.phoneAuthentication(phoneNo);
  }
}
