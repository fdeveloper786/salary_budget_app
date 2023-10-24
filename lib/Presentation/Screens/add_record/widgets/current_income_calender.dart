import 'package:custom_gradient_button/custom_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salary_budget/Data/Core/Utils/app_decoration.dart';
import 'package:salary_budget/Presentation/Screens/add_record/controller/add_record_controller.dart';
import 'package:salary_budget/Presentation/Screens/add_record/widgets/rounded_container.dart';

class CurrentIncomeCalendar extends StatelessWidget {
  final AddRecordController currentDateController;
  BuildContext? incomeContext;

  CurrentIncomeCalendar(
      {required this.currentDateController, this.incomeContext});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Form(
          key: currentDateController.currentDateFormKey,
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
                              currentDateController.currentDateMonthController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: true,
                          enabled: currentDateController.isMonthEnabled.value,
                          decoration: InputDecoration(
                            labelText: 'Select month',
                            suffixIcon: PopupMenuButton<String>(
                              icon: const Icon(Icons.arrow_drop_down),
                              onSelected: (String value) {
                                currentDateController
                                    .currentDateMonthController.text = value;
                                currentDateController
                                    .isCurrentSalaryEnteredEnabled.value = true;
                                currentDateController
                                    .checkExistingMonthlyIncome(
                                        currentDateController
                                            .currentDateMonthController.text,
                                        currentDateController
                                            .currentDateYearController.text);
                              },
                              itemBuilder: (BuildContext context) {
                                return currentDateController.monthList
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
                              currentDateController.currentDateYearController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: true,
                          enabled:
                              true, //currentDateController.isYearEnabled.value,
                          decoration: InputDecoration(
                            labelText: 'Current Year',
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
                        ),
                      ),
                    ],
                  ),
                ),
                (currentDateController.fieldValue.value.toString() == '')
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller:
                              currentDateController.currentSalaryController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          enabled: true,
                          decoration: InputDecoration(
                            labelText: 'Enter month income',
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
                                  currentDateController.submitSalaryForm(
                                      currentDateController.currentDateFormKey,
                                      /*currentDateController
                                      .currentDateYearController.text*/
                                      currentDateController
                                          .currentDateYearController.text,
                                      currentDateController
                                          .currentDateMonthController.text,
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
                              return 'Please enter your income';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            print("salary $value");
                          },
                        ))
                    : RoundedContainer(
                        monthName: currentDateController
                            .currentDateMonthController.text,
                        monthIncome:
                            currentDateController.fieldValue.value.toString(),
                      ),
              ],
            ),
          ));
    });
  }
}
