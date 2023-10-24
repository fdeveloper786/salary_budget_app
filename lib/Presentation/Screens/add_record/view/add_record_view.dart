import 'package:custom_gradient_button/custom_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Data/Core/Utils/app_decoration.dart';
import 'package:salary_budget/Presentation/Screens/add_record/controller/add_record_controller.dart';
import 'package:salary_budget/Presentation/Screens/add_record/widgets/current_income_calender.dart';
import 'package:salary_budget/Presentation/Screens/add_record/widgets/expensed_form.dart';
import 'package:salary_budget/Presentation/Screens/add_record/widgets/previous_income_calender.dart';
import 'package:salary_budget/Presentation/Widgets/common_widgets/screen_buttons.dart';

class AddRecordScreen extends StatefulWidget {
  AddRecordScreen({super.key});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final addRecordController = Get.put(AddRecordController());

  bool isEditable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Record'),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    children: [
                      selectRadioButton(),
                      addReceivedSalary(),
                      recordAddForm(context)
                      /*Obx(() {
                        return Visibility(
                          visible: addRecordController.fieldValue.value.isEmpty
                              ? false
                              : true,
                          child: Center(
                            child: ScreenButtons(
                                btnLabel: "Add Record",
                                onTap: () {
                                  addRecordController.submitRecordForm(context);
                                }),
                          ),
                        );
                      }),*/
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget selectRadioButton() {
    return Row(
      children: [
        Expanded(
          child: Obx(() => Row(
                children: List<Widget>.generate(
                    addRecordController.radioOptions.length, (index) {
                  return Expanded(
                    child: RadioListTile(
                        title: Text(
                            addRecordController.radioOptions[index].toString()),
                        value: index,
                        groupValue: addRecordController.selectedRadio.value,
                        onChanged: (int? value) {
                          addRecordController.selectedRadio.value = value!;
                          addRecordController.changeSelectedValue();
                        }),
                  );
                }),
              )),
        ),
      ],
    );
  }

  Widget addReceivedSalary() {
    return Obx(() {
      return addRecordController.selectedRadio.value.isEqual(0)
          ? CurrentIncomeCalendar(
              currentDateController: addRecordController,
              incomeContext: context,
            )
          : PreviousIncomeCalendar(
              customDateController: addRecordController,
              incomeContext: context,
            );
    });
  }

  Widget recordAddForm(BuildContext context) {
    return Obx(() {
      return addRecordController.selectedRadio.value.isEqual(0)
          ? ExpensesForm(
              controller: addRecordController,
              collectionName: currentYearCollectionNameLbl,
              monthCollectionName:
                  addRecordController.currentDateMonthController,
              yearDocName: addRecordController.currentDateYearController,
              formKey: addRecordController.currAddRecordFormKey,
              expAmntController: addRecordController.expAmountController,
              expTypeController: addRecordController.expTypeController,
              expDateController: addRecordController.expDateController,
              expPartController: addRecordController.expParticularController,
              expPayDateController: addRecordController.payDateController,
              expStatusController: addRecordController.payStatusController,
              ctx: context,
            )
          : ExpensesForm(
              controller: addRecordController,
              collectionName: customYearCollectionNameLbl,
              monthCollectionName:
                  addRecordController.customDateMonthController,
              yearDocName: addRecordController.customDateYearController,
              formKey: addRecordController.custAddRecordFormKey,
              expAmntController: addRecordController.custExpAmountController,
              expTypeController: addRecordController.custExpTypeController,
              expDateController: addRecordController.custExpDateController,
              expPartController:
                  addRecordController.custExpParticularController,
              expPayDateController: addRecordController.custPayDateController,
              expStatusController: addRecordController.custPayStatusController,
              ctx: context,
            );
    });
  }
}
