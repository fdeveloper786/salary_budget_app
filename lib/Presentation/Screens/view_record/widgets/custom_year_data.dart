import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salary_budget/Data/Core/Utils/app_decoration.dart';
import 'package:salary_budget/Presentation/Screens/add_record/widgets/rounded_container.dart';
import 'package:salary_budget/Presentation/Screens/view_record/controller/view_controller.dart';

class CustomYearIncomeRecords extends StatelessWidget {
  final ViewRecordController customYearRecordsController;
  BuildContext? incomeContext;
  CustomYearIncomeRecords(
      {super.key,
      required this.customYearRecordsController,
      this.incomeContext});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller:
                          customYearRecordsController.customDateMonthController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      readOnly: true,
                      enabled: customYearRecordsController.isMonthEnabled.value,
                      decoration: InputDecoration(
                        labelText: 'Select month',
                        suffixIcon: PopupMenuButton<String>(
                          icon: const Icon(Icons.arrow_drop_down),
                          onSelected: (String value) {
                            customYearRecordsController
                                .customDateMonthController.text = value;
                            customYearRecordsController.isYearEnabled.value =
                                true;
                            customYearRecordsController
                                .isPreviousSalaryEnteredEnabled.value = false;
                          },
                          itemBuilder: (BuildContext context) {
                            return customYearRecordsController.monthList
                                .map<PopupMenuItem<String>>((String value) {
                              return new PopupMenuItem(
                                  child: Text(value), value: value);
                            }).toList();
                          },
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                          borderSide: BorderSide(
                            width: 1,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please select month!';
                        }
                        return null;
                      },
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller:
                          customYearRecordsController.customDateYearController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      readOnly: true,
                      enabled: customYearRecordsController.isYearEnabled.value,
                      decoration: InputDecoration(
                        labelText: 'Select year',
                        suffixIcon: PopupMenuButton<String>(
                          icon: const Icon(Icons.arrow_drop_down),
                          onSelected: (String value) {
                            customYearRecordsController
                                .customDateYearController.text = value;
                            customYearRecordsController.isYearEnabled.value =
                                true;
                            customYearRecordsController
                                .isPreviousSalaryEnteredEnabled.value = true;
                            customYearRecordsController
                                .checkExistingMonthlyIncome(
                                    customYearRecordsController
                                        .customDateMonthController.text,
                                    customYearRecordsController
                                        .customDateYearController.text);
                            customYearRecordsController
                                .isMonthYearSelected.value = true;
                          },
                          itemBuilder: (BuildContext context) {
                            return customYearRecordsController.yearList
                                .map<PopupMenuItem<String>>((String value) {
                              return PopupMenuItem(
                                  child: new Text(value), value: value);
                            }).toList();
                          },
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                          borderSide: BorderSide(
                            width: 1,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please select year!';
                        }
                        return null;
                      },
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
            ),
            (customYearRecordsController.fieldValue.value.toString() == '')
                ? (customYearRecordsController.isMonthYearSelected.value ==
                        false)
                    ? Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Please select Month & Year.',
                            style: AppStyle.txtBlack18,
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Income not added,firstly add an income.',
                            style: AppStyle.txtBlack18,
                          ),
                        ),
                      )
                : RoundedContainer(
                    monthName: customYearRecordsController
                        .customDateMonthController.text,
                    monthIncome:
                        customYearRecordsController.fieldValue.value.toString(),
                  )
          ],
        ),
      );
    });
  }
}
