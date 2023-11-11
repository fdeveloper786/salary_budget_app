import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Presentation/Screens/add_record/controller/add_record_controller.dart';
import 'package:salary_budget/Presentation/Screens/view_record/controller/view_controller.dart';

class UpdateRecordController extends GetxController {
  static UpdateRecordController get instance => Get.find();
  AddRecordController addRecordController = Get.put(AddRecordController());
  ViewRecordController viewRecordController = Get.put(ViewRecordController());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final updateFormKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final particularController = TextEditingController();
  final transactionTypeController = TextEditingController();
  final amountController = TextEditingController();
  final statusController = TextEditingController();
  final remarksController = TextEditingController();

  getUpdateForm(BuildContext? ctx, docId, date, particular, transType, amount,
      status, remarks) {
    dateController.text = date;
    particularController.text = particular;
    transactionTypeController.text = transType;
    amountController.text = amount;
    statusController.text = status;
    remarksController.text = remarks;

    Get.dialog(AlertDialog(
      title: Text('Update Record'),
      content: Form(
          key: updateFormKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Expensed Date
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  controller: dateController,
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
                    viewRecordController.selectedRadio.value == 0
                        ? await showDatePicker(
                                context: ctx!,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2023),
                                lastDate: DateTime(2024))
                            .then((selectedDate) {
                            if (selectedDate != null) {
                              dateController.text =
                                  DateFormat('dd-MM-yyyy').format(selectedDate);
                            }
                          })
                        : await showDatePicker(
                                context: ctx!,
                                initialDate: DateTime(2018),
                                firstDate: DateTime(2018),
                                lastDate: DateTime(2022))
                            .then((selectedDate) {
                            if (selectedDate != null) {
                              dateController.text =
                                  DateFormat('dd-MM-yyyy').format(selectedDate);
                            }
                          });
                  },
                  onChanged: (value) {},
                ),
                const SizedBox(
                  height: 10,
                ), // Expensed Particular
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: particularController,
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
                  onChanged: (value) {},
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter particular';
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ), // Expensed Type
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: transactionTypeController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Transaction Type',
                    suffixIcon: PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down),
                      onSelected: (String value) {
                        transactionTypeController.text = value;
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
                  onChanged: (value) {},
                ),
                const SizedBox(
                  height: 10,
                ),
                // Expensed Amount
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: amountController,
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
                  onChanged: (value) {},
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter amount';
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                // Payment Status
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: statusController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Payment Status',
                    suffixIcon: PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down),
                      onSelected: (String value) {
                        statusController.text = value;
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
                  onChanged: (value) {},
                ),

                const SizedBox(
                  height: 10,
                ),
                // Payment Date
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: remarksController,
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
              ],
            ),
          )),
      actions: [
        ElevatedButton(
            onPressed: () {
              updateForm(updateFormKey, docId);
            },
            child: Text('Update'))
      ],
    ));
  }

  void updateForm(formKey, docId) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      print('---validate');
      final documentPath = viewRecordController.user_number;
      print('---update user num $documentPath');
      if (viewRecordController.selectedRadio.value.isEqual(0)) {
        updateData(
            currentYearCollectionNameLbl,
            documentPath,
            viewRecordController.currentDateYearController.text,
            viewRecordController.currentDateMonthController.text,
            docId);
      } else {
        updateData(
            customYearCollectionNameLbl,
            documentPath,
            viewRecordController.customDateYearController.text,
            viewRecordController.customDateMonthController.text,
            docId);
      }
    }
  }

  updateData(collectionName, userNumber, year, month, documentId) async {
    try {
      print('-----------$userNumber $year $month $documentId');
      // Replace 'your_document_id' with the actual document ID
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection(collectionName)
          .doc(userNumber)
          .collection(year)
          .doc(month)
          .collection(expensedLbl)
          .doc(documentId);
      print('doc ref $documentReference');
      // Fetch the document
      DocumentSnapshot documentSnapshot = await documentReference.get();
      print('docSnap $documentSnapshot');
      if (documentSnapshot.exists) {
        Map<String, dynamic> dataToUpdate = {
          'transaction_date': dateController.text,
          'particular': particularController.text,
          'transaction_type': transactionTypeController.text,
          'amount': amountController.text,
          'payment_status': statusController.text,
          'remarks': remarksController.text,
        };
        await documentReference.update(dataToUpdate);
        print('----Date updated successfully');
      } else {
        print('Document does not exist');
      }
    } catch (error) {
      log('---update catch error $error');
    }
  }
}
