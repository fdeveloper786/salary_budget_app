import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salary_budget/Data/Core/Utils/image_utils.dart';
import 'package:salary_budget/Domain/AppRoutes/routes.dart';
import 'package:salary_budget/Presentation/Screens/HomeScreen/controller/home_controller.dart';
import 'package:salary_budget/Presentation/Widgets/chart/chart_container.dart';
import 'package:salary_budget/Presentation/Widgets/chart/pie_chart.dart';
import 'package:salary_budget/Presentation/Widgets/common_widgets/screen_buttons.dart';

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
                      text: homeController.displayName.value.toString() ??
                          'Guest',
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
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
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
                          title: 'Salary Budget Chart',
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
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ScreenButtons(
                                btnLabel: "Add Record",
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(AppRoutes.addRecordScreen);
                                  print('Record added');
                                },
                              ),
                            ),
                            Expanded(
                              child: ScreenButtons(
                                btnLabel: "View Record",
                                onTap: () {
                                  print('Record view');
                                  Get.toNamed(AppRoutes.viewRecordScreen);
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ScreenButtons(
                                btnLabel: "Update Record",
                                onTap: () {
                                  print('Record Updated');
                                },
                              ),
                            ),
                            Expanded(
                              child: ScreenButtons(
                                btnLabel: "Delete Record",
                                onTap: () {
                                  print('Record deleted');
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
