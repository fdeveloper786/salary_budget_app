import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salary_budget/Presentation/Screens/update_record/controller/update_controller.dart';
import 'package:salary_budget/Presentation/Screens/view_record/controller/view_controller.dart';
import 'package:salary_budget/Presentation/Widgets/common_widgets/screen_buttons.dart';

class UpdateRecord extends StatefulWidget {
  final ViewRecordController viewRecordController;
  final String? recordId;
  final String? trDate;
  final String? particular;
  final String? transType;
  final String? amount;
  final String? status;
  final String? remarks;
  UpdateRecord(
      {super.key,
      required this.viewRecordController,
      this.recordId,
      this.trDate,
      this.particular,
      this.transType,
      this.amount,
      this.status,
      this.remarks});

  @override
  State<UpdateRecord> createState() => _UpdateRecordState();
}

class _UpdateRecordState extends State<UpdateRecord> {
  UpdateController updateController = Get.put(UpdateController());

  @override
  void initState() {
    super.initState();
    getDataFromView();
  }

  getDataFromView() {
    updateController.trDateController.text = widget.trDate!;
    updateController.particularController.text = widget.particular!;
    updateController.trTypeController.text = widget.transType!;
    updateController.amountController.text = widget.amount!;
    updateController.payStatusController.text = widget.status!;
    updateController.remarksController.text = widget.remarks!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Update Record'),
        ),
        body: SingleChildScrollView(
          child: updateForm(context),
        )

    );
  }

  updateForm(BuildContext ctx) {
    return Form(
        key: updateController.updateRecordFormKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Expensed Date
              TextFormField(
                keyboardType: TextInputType.datetime,
                controller: updateController.trDateController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Transaction Date',
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
                  widget.viewRecordController.selectedRadio.value == 0
                      ? await showDatePicker(
                              context: context!,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2023),
                              lastDate: DateTime(2024))
                          .then((selectedDate) {
                          if (selectedDate != null) {
                            updateController.trDateController.text =
                                DateFormat('dd-MM-yyyy').format(selectedDate);
                          }
                        })
                      : await showDatePicker(
                              context: context!,
                              initialDate: DateTime(2018),
                              firstDate: DateTime(2018),
                              lastDate: DateTime(2022, 12, 31))
                          .then((selectedDate) {
                          if (selectedDate != null) {
                            updateController.trDateController.text =
                                DateFormat('dd-MM-yyyy').format(selectedDate);
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
                controller: updateController.particularController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Particular',
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
                controller: updateController.trTypeController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Transaction Type',
                  suffixIcon: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      updateController.trTypeController.text = value;
                    },
                    itemBuilder: (BuildContext context) {
                      return updateController.expTypeList
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
                controller: updateController.amountController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Amount',
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
                controller: updateController.payStatusController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Payment Status',
                  suffixIcon: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      updateController.payStatusController.text = value;
                    },
                    itemBuilder: (BuildContext context) {
                      return updateController.paymentStatusList
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

              const SizedBox(
                height: 10,
              ),
              // Payment Date
              TextFormField(
                keyboardType: TextInputType.text,
                controller: updateController.remarksController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                readOnly: false,
                decoration: InputDecoration(
                  labelText: 'Remarks',
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
              ),
              SizedBox(height: 16),
              Center(
                  child: ScreenButtons(
                onTap: () {
                  print('update button pressed');
                  updateController.validateForm(widget.recordId, ctx);
                },
                btnLabel: 'Update',
              ))
            ],
          ),
        ));
  }
}
