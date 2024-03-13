import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Presentation/Screens/view_record/controller/view_controller.dart';
import 'package:salary_budget/Presentation/Widgets/common_widgets/common_widgets.dart';

class UpdateController extends GetxController {
  final updateRecordFormKey = GlobalKey<FormState>();

  final trDateController = TextEditingController();
  final particularController = TextEditingController();
  final trTypeController = TextEditingController();
  final amountController = TextEditingController();
  final payStatusController = TextEditingController();
  final remarksController = TextEditingController();
  var paymentStatusList = [
    'Fully Paid',
    'Partially Paid',
  ].obs;
  var expTypeList = [
    'Credit',
    'Debit',
  ].obs;
  var isLoading = false.obs;
  validateForm(recordId, BuildContext context) async {
    if (updateRecordFormKey.currentState!.validate()) {
      updateRecordFormKey.currentState!.save();
      log('validated... ${recordId}');
      if (ViewRecordController.instance.selectedRadio.value == 0) {
        log('selected 0 ');
        await updateRecord(
            expensedDataCollectionLbl,
            ViewRecordController.instance.user_number,
            ViewRecordController.instance.currentDateYearController.text,
            ViewRecordController.instance.currentDateMonthController.text,
            recordId,
            context);
      } else {
        log('selected 1');
        await updateRecord(
            expensedDataCollectionLbl,
            ViewRecordController.instance.user_number,
            ViewRecordController.instance.customDateYearController.text,
            ViewRecordController.instance.customDateMonthController.text,
            recordId,
            context);
      }
    }
  }

  commonSnackbar(String title, String body) {
    Get.snackbar(
      title,
      body,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red[600],
      colorText: Colors.white,
      duration: Duration(seconds: 5),
    );
  }

  updateRecord(collectionName, userNumber, year, month, documentId,
      BuildContext ctx) async {
    log('Updating record');
    try {
      isLoading.value = true;
      WidgetsHelper.onSubmitData(ctx, 'Updating...');
      Map<String, dynamic> dataToUpdate = {
        'transaction_date': trDateController.text,
        'particular': particularController.text,
        'transaction_type': trTypeController.text,
        'amount': amountController.text,
        'payment_status': payStatusController.text,
        'remarks': remarksController.text,
      };
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection(collectionName)
          .doc(userNumber)
          .collection(year)
          .doc(month)
          .collection(expensedLbl)
          .doc(documentId);
      log('doc ref ${documentReference.id}');
      DocumentSnapshot documentSnapshot = await documentReference.get();
      if (documentSnapshot.exists) {
        await documentReference.update(dataToUpdate);
        await ViewRecordController.instance.getData(collectionName,userNumber,year,month);
        Navigator.of(ctx).pop();
        Get.back();
        clearTextField();
      } else {
        log('Document not exits');
        Navigator.of(ctx).pop();
        commonSnackbar('Error occurred !', 'Something missing in DB');
      }
    } catch (e) {
      print('catch error2 $e');
      Navigator.of(ctx).pop();
    }
  }

  clearTextField() {
    trDateController.clear();

    particularController.clear();

    trTypeController.clear();

    amountController.clear();

    payStatusController.clear();

    remarksController.clear();
  }
}
