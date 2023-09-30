import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Presentation/Screens/Login/login_screen.dart';
import 'package:salary_budget/Presentation/Widgets/common_widgets/common_widgets.dart';
import 'package:salary_budget/repository/authenticaion_repository.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();
  var userName = " ".obs;
  var greetingsMsg = ''.obs;
  var currentTime = int.parse(DateFormat('kk').format(DateTime.now()));
  var currentMonthName = "".obs;

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
    greetingsMessage();
    getCurrentMonthName();
  }

  getUserName() async {
    try {
      userName.value =
          await AuthenticationRepository.instance.userLoggedNumber();
      print('username ${userName.value}');
    } catch (e) {
      print('e $e');
    }
  }

  String greetingsMessage() {
    if (currentTime <= 12) {
      greetingsMsg.value = "Good Morning\t";
    } else if ((currentTime > 12) && (currentTime <= 17)) {
      greetingsMsg.value = "Good Afternoon\t";
    } else if ((currentTime > 17) && (currentTime <= 20)) {
      greetingsMsg.value = "Good Evening\t";
    } else {
      greetingsMsg.value = "Good Night\t";
    }
    return greetingsMsg.value;
  }

  String getCurrentMonthName() {
    final now = DateTime.now();
    final formatter = DateFormat.MMMM(); // Use 'MMMM' for the full month name or 'MMM' for the abbreviated name
    final monthName = formatter.format(now);
    print("monthname $monthName");
    currentMonthName.value = monthName;
    return currentMonthName.value;
  }
}
