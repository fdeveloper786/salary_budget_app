import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Data/Core/Utils/image_utils.dart';
import 'package:salary_budget/Presentation/Widgets/Screens/HomeScreen/controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(homeScreenTitleLbl),
        actions: [
          IconButton(
              onPressed: () {
                homeController.userLoggedOut(context);
              },
              icon: Icon(
                Icons.logout_rounded,
                color: Colors.black,
                size: 25,
              ))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset(
              AssetsUtils.splashScreenJpg,
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
            ),
            Text('Welcome to Salary Budget App',style: const TextStyle(
              fontSize: 20.0,fontWeight: FontWeight.w700
            ),),
          ],
        ),
      ),
    );
  }
}
