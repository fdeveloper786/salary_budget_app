import 'dart:developer';
import 'package:custom_gradient_button/custom_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salary_budget/Data/Core/Utils/image_utils.dart';
import 'package:salary_budget/Presentation/Widgets/Screens/HomeScreen/controller/home_controller.dart';
import 'package:salary_budget/Presentation/Widgets/chart/chart_container.dart';
import 'package:salary_budget/Presentation/Widgets/chart/pie_chart.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Obx(() {
            return RichText(
              text: TextSpan(
                  text: homeController.greetingsMsg.value.toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                  children: <TextSpan>[
                    TextSpan(
                      text: homeController.userName.value.toString() ?? '',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          fontSize: 20),
                    ),
                  ]),
            );
          }),
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
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Image.asset(
                      AssetsUtils.splashScreenJpg,
                      height: MediaQuery.of(context).size.height / 5.8,
                      width: MediaQuery.of(context).size.width,
                    ),
                    ChartContainer(
                        title: 'Pie Chart',
                        color: Colors.greenAccent,
                        chart: PieChartContent()),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Welcome to Salary Budget App',
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomGradientButton(
                        child: const Text(
                          'Add Record',
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        height: 50.0,
                        width: 250.0,
                        firstColor: Colors.greenAccent,
                        secondColor: Colors.blueAccent,
                        method: () {
                          print('hello addition');
                        },
                      ),
                      CustomGradientButton(
                        child: const Text(
                          'View Record',
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        height: 50.0,
                        width: 250.0,
                        firstColor: Colors.greenAccent,
                        secondColor: Colors.blueAccent,
                        method: () {
                          print('hello addition');
                        },
                      ),
                      CustomGradientButton(
                        child: const Text(
                          'Update Record',
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        height: 50.0,
                        width: 250.0,
                        firstColor: Colors.greenAccent,
                        secondColor: Colors.blueAccent,
                        method: () {
                          print('hello addition');
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
