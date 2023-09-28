import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Presentation/Widgets/Screens/Login/login_screen.dart';
import 'package:salary_budget/Presentation/Widgets/common_widgets/common_widgets.dart';
import 'package:salary_budget/repository/authenticaion_repository.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  void userLoggedOut(BuildContext context) async {
    bool? isLoggedOut;
    try {
      isLoggedOut = await AuthenticationRepository.instance.userLoggedOut();
      WidgetsHelper.onLoadingPage(context);
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context); //pop dialog
        if (isLoggedOut!) {
          Get.offAll(LoginScreen());
        } else {
          Get.snackbar(errorLbl, somethingWentWrongLbl);
        }
        //isVerified! ? Get.offAll(HomeScreen()) : Get.to(()=>LoginScreen());//Get.back();
      });
    } catch (e) {
      print('exception $e');
    }
  }
}
