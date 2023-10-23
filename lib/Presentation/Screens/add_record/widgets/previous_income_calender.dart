import 'package:custom_gradient_button/custom_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salary_budget/Data/Core/Utils/app_decoration.dart';
import 'package:salary_budget/Presentation/Screens/add_record/controller/add_record_controller.dart';
import 'package:salary_budget/Presentation/Screens/add_record/widgets/rounded_container.dart';

class PreviousIncomeCalendar extends StatelessWidget {
  final AddRecordController customDateController;
  BuildContext? incomeContext;

  PreviousIncomeCalendar(
      {required this.customDateController, this.incomeContext});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Form(
          key: customDateController.previousDateFormKey,
          child: Padding(
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
                              customDateController.customDateMonthController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: true,
                          enabled: customDateController.isMonthEnabled.value,
                          decoration: InputDecoration(
                            labelText: 'Select month',
                            suffixIcon: PopupMenuButton<String>(
                              icon: const Icon(Icons.arrow_drop_down),
                              onSelected: (String value) {
                                customDateController
                                    .customDateMonthController.text = value;
                                customDateController.isYearEnabled.value = true;
                                customDateController
                                    .isPreviousSalaryEnteredEnabled
                                    .value = false;
                              },
                              itemBuilder: (BuildContext context) {
                                return customDateController.monthList
                                    .map<PopupMenuItem<String>>((String value) {
                                  return new PopupMenuItem(
                                      child: Text(value), value: value);
                                }).toList();
                              },
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
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
                              customDateController.customDateYearController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: true,
                          enabled: customDateController.isYearEnabled.value,
                          decoration: InputDecoration(
                            labelText: 'Select year',
                            suffixIcon: PopupMenuButton<String>(
                              icon: const Icon(Icons.arrow_drop_down),
                              onSelected: (String value) {
                                customDateController
                                    .customDateYearController.text = value;
                                customDateController.isYearEnabled.value = true;
                                customDateController
                                    .isPreviousSalaryEnteredEnabled
                                    .value = true;
                                customDateController.checkExistingMonthlyIncome(
                                    customDateController
                                        .customDateMonthController.text,
                                    customDateController
                                        .customDateYearController.text);
                              },
                              itemBuilder: (BuildContext context) {
                                return customDateController.yearList
                                    .map<PopupMenuItem<String>>((String value) {
                                  return PopupMenuItem(
                                      child: new Text(value), value: value);
                                }).toList();
                              },
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
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
                (customDateController.fieldValue.value.toString() == '')
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller:
                              customDateController.customSalaryController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          enabled: customDateController
                              .isPreviousSalaryEnteredEnabled.value,
                          decoration: InputDecoration(
                            labelText: 'Enter month salary',
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomGradientButton(
                                child: Text(
                                  'Add',
                                  style: AppStyle.txtWhite15,
                                ),
                                height: 20.0,
                                width: 40.0,
                                firstColor: Colors.greenAccent,
                                secondColor: Colors.blueAccent,
                                method: () {
                                  customDateController.submitSalaryForm(
                                      customDateController.previousDateFormKey,
                                      customDateController
                                          .customDateYearController.text,
                                      customDateController
                                          .customDateMonthController.text,
                                      incomeContext);
                                },
                              ),
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
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
                              return 'Please enter your received salary';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            print("salary $value");
                          },
                        ),
                      )
                    : RoundedContainer(
                        monthName:
                            customDateController.customDateMonthController.text,
                        monthIncome:
                            customDateController.fieldValue.value.toString(),
                      ),
              ],
            ),
          ));
    });
  }
}
