import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Data/Core/Utils/app_decoration.dart';
import 'package:salary_budget/Domain/extensions/extensions.dart';
import 'package:salary_budget/Presentation/Screens/view_record/controller/view_controller.dart';
import 'package:salary_budget/Presentation/Widgets/common_widgets/rich_text.dart';

class CalculationNavbar extends StatelessWidget {
  final ViewRecordController? viewRecordController;

  const CalculationNavbar({super.key, this.viewRecordController});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white, // Container background color
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0),
          topLeft: Radius.circular(10.0),
        ), // Optional: Add rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 5, // Spread radius
            blurRadius: 7, // Blur radius
            offset: Offset(0, 3), // Offset from the top
          ),
        ],
      ),
      child: calculationWidget(),
    );
  }

  Widget calculationWidget() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 07.0, vertical: 05.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomRichText(
              text: totalDebitedLbl,
              textStyle: AppStyle.txtBlack15,
              value: '-\t' +
                  viewRecordController!.totalDebitedAmount
                      .toStringAsFixed(2)
                      .formatAsCurrency(),
              valueStyle: AppStyle.txtBlackBold15.copyWith(color: Colors.red),
            ),
            const SizedBox(
              height: 05,
            ),
            CustomRichText(
              text: totalCreditedLbl,
              textStyle: AppStyle.txtBlack15,
              value: '+\t' +
                  viewRecordController!.totalCreditedAmount.value
                      .toStringAsFixed(2)
                      .formatAsCurrency(),
              valueStyle: AppStyle.txtBlackBold15.copyWith(color: Colors.green),
            ),
            const SizedBox(
              height: 05,
            ),
            Divider(
              color: Colors.black,
              thickness: 1.0,
              height: 0.5,
            ),
            CustomRichText(
              text: totalBalanceLbl,
              textStyle: AppStyle.txtBlack20Plain,
              value: viewRecordController!.totalBalance.value
                  .toStringAsFixed(2)
                  .formatAsCurrency(), //'33,987.00',
              valueStyle:
              AppStyle.txtBlack20.copyWith(color: Colors.blueAccent),
            ),
          ],
        ),
      );
    });
  }
}