import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Presentation/Widgets/Screens/Login/login_screen.dart';
import 'package:salary_budget/Presentation/Widgets/common_widgets/common_widgets.dart';
import 'package:salary_budget/repository/authenticaion_repository.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();
  var userName = " ".obs;
  var greetingsMsg = ''.obs;
  DateTime? currentDate = DateTime.now();

  void userLoggedOut(BuildContext context) async {
    bool? isLoggedOut;
    try {
      isLoggedOut = await AuthenticationRepository.instance.userLoggedOut();
      WidgetsHelper.onLoadingPage(context);
      Future.delayed(const Duration(seconds: 3), () async {
        Navigator.pop(context); //pop dialog
        if (isLoggedOut!) {
          await AuthenticationRepository.instance.removedUserName();
          Get.offAll(LoginScreen());
        } else {
          Get.snackbar(errorLbl, somethingWentWrongLbl);
        }
      });
    } catch (e) {
      print('exception $e');
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit

    getUserName();
    super.onInit();
  }

  getUserName() async {
    try {
      userName.value =
          await AuthenticationRepository.instance.userLoggedNumber();
      print('username ${userName.value}');
      greetingsMessage();
    } catch (e) {
      print('e $e');
    }
  }

  String greetingsMessage() {
    if (currentDate!.hour < 12) {
      greetingsMsg.value = "Good morning,\t";
    }
    if (currentDate!.hour < 17) {
      greetingsMsg.value = "Good afternoon,\t";
    }
    return greetingsMsg.value = "Good evening,\t";
  }
}
