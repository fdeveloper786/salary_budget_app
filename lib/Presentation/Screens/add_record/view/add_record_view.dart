import 'package:custom_gradient_button/custom_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salary_budget/Data/Core/Utils/app_decoration.dart';
import 'package:salary_budget/Presentation/Screens/add_record/controller/add_record_controller.dart';
import 'package:salary_budget/Presentation/Screens/add_record/widgets/current_income_calender.dart';
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
                      addRecordForm(context),
                      Center(
                        child: ScreenButtons(
                            btnLabel: "Add Record",
                            onTap: () {
                              addRecordController.submitRecordForm(context);
                            }),
                      ),
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

  Widget addRecordForm([BuildContext? ctx]) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
          key: addRecordController.addRecordFormKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Expensed Amount
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: addRecordController.expAmountController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Expensed amount',
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
                      return 'Please enter your expense amount!';
                    }
                    return null;
                  },
                  onChanged: (value) {},
                ),
                const SizedBox(
                  height: 10,
                ),
                // Expensed Type
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: addRecordController.expTypeController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Expensed type',
                    suffixIcon: PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down),
                      onSelected: (String value) {
                        addRecordController.expTypeController.text = value;
                      },
                      itemBuilder: (BuildContext context) {
                        return addRecordController.expTypeList
                            .map<PopupMenuItem<String>>((String value) {
                          return new PopupMenuItem(
                              child: new Text(value), value: value);
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
                      return 'Please enter your expense type!';
                    }
                    return null;
                  },
                  onChanged: (value) {},
                ),
                const SizedBox(
                  height: 10,
                ),
                // Expensed Date
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  controller: addRecordController.expDateController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Expensed Date',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    suffixIcon: Icon(Icons.calendar_month_rounded),
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
                  onTap: () async {
                    await showDatePicker(
                            context: ctx!,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2099))
                        .then((selectedDate) {
                      if (selectedDate != null) {
                        addRecordController.expDateController.text =
                            DateFormat('dd-MM-yyyy').format(selectedDate);
                      }
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your expensed date!';
                    }
                    return null;
                  },
                  onChanged: (value) {},
                ),
                const SizedBox(
                  height: 10,
                ),
                // Expensed Particular
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: addRecordController.expParticularController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Expensed Particular',
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
                      return 'Please enter your expensed particular';
                    }
                    return null;
                  },
                  onChanged: (value) {},
                ),
                const SizedBox(
                  height: 10,
                ),
                // Payment Date
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  controller: addRecordController.payDateController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Payment Date',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    suffixIcon: Icon(Icons.calendar_month_rounded),
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
                  onTap: () async {
                    await showDatePicker(
                            context: ctx!,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2099))
                        .then((selectedDate) {
                      if (selectedDate != null) {
                        addRecordController.payDateController.text =
                            DateFormat('dd-MM-yyyy').format(selectedDate);
                      }
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your payment date!';
                    }
                    return null;
                  },
                  onChanged: (value) {},
                ),
                const SizedBox(
                  height: 10,
                ),
                // Payment Status
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: addRecordController.payStatusController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Payment Status',
                    suffixIcon: PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down),
                      onSelected: (String value) {
                        addRecordController.payStatusController.text = value;
                      },
                      itemBuilder: (BuildContext context) {
                        return addRecordController.paymentStatusList
                            .map<PopupMenuItem<String>>((String value) {
                          return new PopupMenuItem(
                              child: new Text(value), value: value);
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
                      return 'Please enter your payment status!';
                    }
                    return null;
                  },
                  onChanged: (value) {},
                ),
                SizedBox(height: 16),
              ],
            ),
          )),
    );
  }
}
