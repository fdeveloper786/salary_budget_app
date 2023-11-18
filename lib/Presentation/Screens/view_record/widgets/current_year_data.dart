// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salary_budget/Data/Core/Utils/app_decoration.dart';
import 'package:salary_budget/Presentation/Screens/add_record/widgets/rounded_container.dart';
import 'package:salary_budget/Presentation/Screens/view_record/controller/view_controller.dart';

class CurrentYearIncomeRecords extends StatelessWidget {
  final ViewRecordController currentYearRecordsController;
  BuildContext? incomeContext;

  CurrentYearIncomeRecords(
      {required this.currentYearRecordsController, this.incomeContext});

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
                      controller: currentYearRecordsController
                          .currentDateMonthController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      readOnly: true,
                      enabled: true,
                      decoration: InputDecoration(
                        labelText: 'Select month',
                        suffixIcon: PopupMenuButton<String>(
                          icon: const Icon(Icons.arrow_drop_down),
                          onSelected: (String value) {
                            currentYearRecordsController
                                .currentDateMonthController.text = value;
                            currentYearRecordsController
                                .checkExistingMonthlyIncome(
                                    currentYearRecordsController
                                        .currentDateMonthController.text,
                                    currentYearRecordsController
                                        .currentDateYearController.text);
                          },
                          itemBuilder: (BuildContext context) {
                            return currentYearRecordsController.monthList
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
                      controller: currentYearRecordsController
                          .currentDateYearController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      readOnly: true,
                      enabled:
                          true, //currentDateController.isYearEnabled.value,
                      decoration: InputDecoration(
                        labelText: 'Current Year',
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
                    ),
                  ),
                ],
              ),
            ),
            (currentYearRecordsController.fieldValue.value.toString() == '')
                ? Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Income not added,firstly add an income.',
                        style: AppStyle.txtBlack18,
                      ),
                    ),
                  )
                : RoundedContainer(
                    monthName: currentYearRecordsController
                        .currentDateMonthController.text,
                    monthIncome: currentYearRecordsController.fieldValue.value
                        .toString(),
                  ),
          ],
        ),
      );
    });
  }
}
