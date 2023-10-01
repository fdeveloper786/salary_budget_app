import 'package:custom_gradient_button/custom_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salary_budget/Data/Core/Utils/app_decoration.dart';
import 'package:salary_budget/Presentation/Screens/add_record/controller/add_record_controller.dart';
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
                      addReceivedSalary(context),
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

  Widget addReceivedSalary(BuildContext salaryCtx) {
    return Obx(
      () {
        return Form(
            key: addRecordController.addSalaryFormKey,
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
                            controller: addRecordController.monthController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            readOnly: true,
                            enabled: addRecordController.isMonthEnabled.value,
                            decoration: InputDecoration(
                              labelText: 'Select month',
                              suffixIcon: PopupMenuButton<String>(
                                icon: const Icon(Icons.arrow_drop_down),
                                onSelected: (String value) {
                                  addRecordController.monthController.text = value;
                                  addRecordController.isYearEnabled.value = true;
                                  addRecordController.isSalaryEnteredEnabled.value = false;
                                },
                                itemBuilder: (BuildContext context) {
                                  return addRecordController.monthList
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
                            controller: addRecordController.yearController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            readOnly: true,
                            enabled: addRecordController.isYearEnabled.value,
                            decoration: InputDecoration(
                              labelText: 'Select year',
                              suffixIcon: PopupMenuButton<String>(
                                icon: const Icon(Icons.arrow_drop_down),
                                onSelected: (String value) {
                                  addRecordController.yearController.text = value;
                                  //addRecordController.isYearEnabled.value = true;
                                  addRecordController.isSalaryEnteredEnabled.value = true;
                                },
                                itemBuilder: (BuildContext context) {
                                  return addRecordController.yearList
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: addRecordController.salaryController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      enabled: addRecordController.isSalaryEnteredEnabled.value,
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
                              addRecordController.submitSalaryForm(
                                  addRecordController.yearController.text,
                                  addRecordController.monthController.text,
                                  salaryCtx);
                            },
                          ),
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
                          return 'Please enter your received salary';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        print("salary $value");
                      },
                    ),
                  ),
                ],
              ),
            ));
      }
    );
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
