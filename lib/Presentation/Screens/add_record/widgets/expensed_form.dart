/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salary_budget/Presentation/Screens/add_record/controller/add_record_controller.dart';
import 'package:salary_budget/Presentation/Widgets/common_widgets/screen_buttons.dart';

class ExpensesForm extends StatelessWidget {
  final AddRecordController controller;
  final String collectionName;
  final TextEditingController monthCollectionName;
  final TextEditingController yearDocName;
  final GlobalKey<FormState> formKey;
  final TextEditingController transDateController;
  final TextEditingController transPartController;
  final TextEditingController transTypeController;
  final TextEditingController transAmntController;
  final TextEditingController transPayStatusController;
  final TextEditingController transRemarksController;
  BuildContext? ctx;

  ExpensesForm(
      {super.key,
      required this.controller,
      required this.collectionName,
      required this.monthCollectionName,
      required this.yearDocName,
      required this.formKey,
      required this.transDateController,
      required this.transPartController,
      required this.transTypeController,
      required this.transAmntController,
      required this.transPayStatusController,
      required this.transRemarksController,
      this.ctx});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Visibility(
        visible: controller.fieldValue.value.isEmpty ? false : true,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Expensed Date
                        TextFormField(
                          keyboardType: TextInputType.datetime,
                          controller: transDateController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Transaction Date',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
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
                            controller.selectedRadio.value == 0
                                ? await showDatePicker(
                                        context: ctx!,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2023),
                                        lastDate: DateTime(2024))
                                    .then((selectedDate) {
                                    if (selectedDate != null) {
                                      transDateController.text =
                                          DateFormat('dd-MM-yyyy')
                                              .format(selectedDate);
                                    }
                                  })
                                : await showDatePicker(
                                        context: ctx!,
                                        initialDate: DateTime(2018),
                                        firstDate: DateTime(2018),
                                        lastDate: DateTime(2022))
                                    .then((selectedDate) {
                                    if (selectedDate != null) {
                                      transDateController.text =
                                          DateFormat('dd-MM-yyyy')
                                              .format(selectedDate);
                                    }
                                  });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Transaction Date!';
                            }
                            return null;
                          },
                          onChanged: (value) {},
                        ),
                        const SizedBox(
                          height: 10,
                        ), // Expensed Particular
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: transPartController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: 'Particular',
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
                              return 'Please enter your particular';
                            }
                            return null;
                          },
                          onChanged: (value) {},
                        ),
                        const SizedBox(
                          height: 10,
                        ), // Expensed Type
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: transTypeController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Transaction Type',
                            suffixIcon: PopupMenuButton<String>(
                              icon: const Icon(Icons.arrow_drop_down),
                              onSelected: (String value) {
                                transTypeController.text = value;
                              },
                              itemBuilder: (BuildContext context) {
                                return controller.expTypeList
                                    .map<PopupMenuItem<String>>((String value) {
                                  return new PopupMenuItem(
                                      child: new Text(value), value: value);
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
                              return 'Please enter your Transaction Type!';
                            }
                            return null;
                          },
                          onChanged: (value) {},
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Expensed Amount
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: transAmntController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: 'Amount',
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
                              return 'Please enter your amount!';
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
                          controller: transPayStatusController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Payment Status',
                            suffixIcon: PopupMenuButton<String>(
                              icon: const Icon(Icons.arrow_drop_down),
                              onSelected: (String value) {
                                transPayStatusController.text = value;
                              },
                              itemBuilder: (BuildContext context) {
                                return controller.paymentStatusList
                                    .map<PopupMenuItem<String>>((String value) {
                                  return new PopupMenuItem(
                                      child: new Text(value), value: value);
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
                              return 'Please enter your payment status!';
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
                          keyboardType: TextInputType.text,
                          controller: transRemarksController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: false,
                          decoration: InputDecoration(
                            labelText: 'Remarks',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            // suffixIcon: Icon(Icons.calendar_month_rounded),
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
                          /* onTap: () async {
                            controller.selectedRadio.value == 0
                                ? await showDatePicker(
                                context: ctx!,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2023),
                                lastDate: DateTime(2024))
                                .then((selectedDate) {
                              if (selectedDate != null) {
                                expPayDateController.text =
                                    DateFormat('dd-MM-yyyy')
                                        .format(selectedDate);
                              }
                            })
                                : await showDatePicker(
                                context: ctx!,
                                initialDate: DateTime(2018),
                                firstDate: DateTime(2018),
                                lastDate: DateTime(2022))
                                .then((selectedDate) {
                              if (selectedDate != null) {
                                expPayDateController.text =
                                    DateFormat('dd-MM-yyyy')
                                        .format(selectedDate);
                              }
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your payment date!';
                            }
                            return null;
                          },
                          onChanged: (value) {},*/
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  )),
              Obx(() {
                return Visibility(
                  visible: controller.fieldValue.value.isEmpty ? false : true,
                  child: Center(
                    child: ScreenButtons(
                        btnLabel: "Add Record",
                        onTap: () {
                          controller.submitRecordForm(
                            context,
                            collectionName,
                            monthCollectionName.text,
                            yearDocName.text,
                            formKey,
                            transDateController.text,
                            transPartController.text,
                            transTypeController.text,
                            transAmntController.text,
                            transPayStatusController.text,
                            transRemarksController.text,
                          );
                        }),
                  ),
                );
              }),
            ],
          ),
        ),
      );
    });
  }
}
*/
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salary_budget/Presentation/Screens/add_record/controller/add_record_controller.dart';
import 'package:salary_budget/Presentation/Widgets/common_widgets/screen_buttons.dart';

class ExpensesForm extends StatefulWidget {
  final AddRecordController controller;
  final String collectionName;
  final TextEditingController monthCollectionName;
  final TextEditingController yearDocName;
  final GlobalKey<FormState> formKey;
  final TextEditingController transDateController;
  final TextEditingController transPartController;
  final TextEditingController transTypeController;
  final TextEditingController transAmntController;
  final TextEditingController transPayStatusController;
  final TextEditingController transRemarksController;
  BuildContext? ctx;

  ExpensesForm(
      {super.key,
      required this.controller,
      required this.collectionName,
      required this.monthCollectionName,
      required this.yearDocName,
      required this.formKey,
      required this.transDateController,
      required this.transPartController,
      required this.transTypeController,
      required this.transAmntController,
      required this.transPayStatusController,
      required this.transRemarksController,
      this.ctx});

  @override
  State<ExpensesForm> createState() => _ExpensesFormState();
}

class _ExpensesFormState extends State<ExpensesForm> {
  DateTime? initialDate;
  DateTime? firstDate;

  DateTime? lastDate;

  int currentYear = DateTime.now().year;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // if (widget.controller.selectedRadio.value == 0) {
    //   lastDate = DateTime(
    //       currentYear, 12, 31); // Set to the last day of the current year
    //   initialDate =
    //       DateTime.now().isBefore(lastDate!) ? DateTime.now() : lastDate;
    //   firstDate = DateTime(currentYear, 1, 1); // Set to the first day of 2024
    // } else {
    //   initialDate = DateTime(currentYear - 5);
    //   firstDate = DateTime(currentYear - 5);
    //   lastDate = DateTime(currentYear - 1, 12, 31);
    // }
  }
  String? selectedExpType;
  String? selectedPayStatus;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Visibility(
        visible: widget.controller.fieldValue.value.isEmpty ? false : true,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Form(
                  key: widget.formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Expensed Date
                        TextFormField(
                          keyboardType: TextInputType.datetime,
                          controller: widget.transDateController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Transaction Date',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
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
                            if (widget.controller.selectedRadio.value == 0) {
                              lastDate = DateTime(currentYear, 12,
                                  31); // Set to the last day of the current year
                              initialDate = DateTime.now().isBefore(lastDate!)
                                  ? DateTime.now()
                                  : lastDate;
                              firstDate = DateTime(currentYear, 1,
                                  1); // Set to the first day of 2024
                            } else {
                              initialDate = DateTime(currentYear - 5);
                              firstDate = DateTime(currentYear - 5);
                              lastDate = DateTime(currentYear - 1, 12, 31);
                            }
                            // widget.controller.selectedRadio.value == 0
                            //     ? await showDatePicker(
                            //             context: widget.ctx!,
                            //             initialDate: DateTime.now(),
                            //             firstDate: DateTime(currentYear - 1),
                            //             lastDate: DateTime(currentYear))
                            //         .then((selectedDate) {
                            //         if (selectedDate != null) {
                            //           widget.transDateController.text =
                            //               DateFormat('dd-MM-yyyy')
                            //                   .format(selectedDate);
                            //         }
                            //       })
                            //     : await showDatePicker(
                            //             context: widget.ctx!,
                            //             initialDate: DateTime(currentYear - 5),
                            //             firstDate: DateTime(currentYear - 5),
                            //             lastDate:
                            //                 DateTime(currentYear - 1, 12, 31))
                            //         .then((selectedDate) {
                            //         if (selectedDate != null) {
                            //           widget.transDateController.text =
                            //               DateFormat('dd-MM-yyyy')
                            //                   .format(selectedDate);
                            //         }
                            //       });
                            await showDatePicker(
                              context: widget.ctx!,
                              initialDate: initialDate,
                              firstDate: firstDate!,
                              lastDate: lastDate!,
                            ).then((selectedDate) {
                              if (selectedDate != null) {
                                widget.transDateController.text =
                                    DateFormat('dd-MM-yyyy')
                                        .format(selectedDate);
                              }
                            });
                          },
                           validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Transaction Date!';
                            }
                            return null;
                          },
                          onChanged: (value) {},
                        ),
                        const SizedBox(
                          height: 10,
                        ), // Expensed Particular
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: widget.transPartController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: 'Particular',
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
                          maxLength: 20,
                           validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your particular';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            print('text length ${value.length}');
                          },
                        ),
                        // Expense Type Dropdown
                        DropdownButtonFormField2<String>(
                          decoration: InputDecoration(
                            labelText: 'Expense Type',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          isExpanded: true,
                          value: selectedExpType,
                          hint: const Text('Select Expense Type'),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          items: widget.controller.expTypeList
                              .map((type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedExpType = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an expense type.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Expensed Amount
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: widget.transAmntController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: 'Amount',
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
                          maxLength: 6,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your amount!';
                            } if(value.length > 6) {
                              return 'Please enter less than 6 digit';
                            }
                            return null;
                          },
                          onChanged: (value) {},
                        ),
                        // Payment Status
                        DropdownButtonFormField2<String>(
                          decoration: InputDecoration(
                            labelText: 'Payment Status',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          isExpanded: true,
                          value: selectedPayStatus,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          hint: const Text('Select Payment Status'),
                          items: widget.controller.paymentStatusList
                              .map((status) => DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedPayStatus = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a payment status.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Payment Date
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: widget.transRemarksController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: false,
                          decoration: InputDecoration(
                            labelText: 'Remarks',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            // suffixIcon: Icon(Icons.calendar_month_rounded),
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
                          maxLength: 50,
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  )),
              Obx(() {
                return Visibility(
                  visible:
                      widget.controller.fieldValue.value.isEmpty ? false : true,
                  child: Center(
                    child: ScreenButtons(
                        btnLabel: "Add Record",
                        onTap: () {
                          widget.controller.submitRecordForm(
                            context,
                            widget.collectionName,
                            widget.monthCollectionName.text,
                            widget.yearDocName.text,
                            widget.formKey,
                            widget.transDateController.text,
                            widget.transPartController.text,
                            selectedExpType,
                            widget.transAmntController.text,
                            selectedPayStatus,
                            widget.transRemarksController.text,
                          );
                        }),
                  ),
                );
              }),
            ],
          ),
        ),
      );
    });
  }
}
