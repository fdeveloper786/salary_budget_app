import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Presentation/Screens/Login/login_screen.dart';
import 'package:salary_budget/Presentation/Widgets/common_widgets/common_widgets.dart';
import 'package:salary_budget/repository/authenticaion_repository.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  var greetingsMsg = ''.obs;
  var currentTime = int.parse(DateFormat('kk').format(DateTime.now()));
  var currentMonthName = "".obs;
  var displayName = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    getUserName();
    greetingsMessage();
    getCurrentMonthName();
  }

  Future<String?> getUserName() async {
    try {
      displayName.value =
          await AuthenticationRepository.instance.loggedUserName();
      return displayName.value;
    } catch (e) {
      print('e $e');
    }
  }

  void userLoggedOut(BuildContext context) async {
    bool? isLoggedOut;
    try {
      isLoggedOut = await AuthenticationRepository.instance.userLoggedOut();
      WidgetsHelper.onLoadingPage(context);
      Future.delayed(const Duration(seconds: 2), () async {
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

  String greetingsMessage() {
    if (currentTime <= 12) {
      greetingsMsg.value = "Good Morning\t";
    } else if ((currentTime > 12) && (currentTime <= 16)) {
      greetingsMsg.value = "Good Afternoon\t";
    } else if ((currentTime > 16) && (currentTime <= 24)) {
      greetingsMsg.value = "Good Evening\t";
    } /*else if ((currentTime > 20) && (currentTime <= )){
      greetingsMsg.value = "Good Night\t";
    }*/
    return greetingsMsg.value;
  }

  String getCurrentMonthName() {
    final now = DateTime.now();
    final formatter = DateFormat
        .MMMM(); // Use 'MMMM' for the full month name or 'MMM' for the abbreviated name
    final monthName = formatter.format(now);
    print("monthname $monthName");
    currentMonthName.value = monthName;
    return currentMonthName.value;
  }
}
