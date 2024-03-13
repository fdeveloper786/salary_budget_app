import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Presentation/Screens/view_record/view/view_record_tile_model.dart';
import 'package:salary_budget/Presentation/Screens/download_record/download_record_controller.dart';
import 'package:salary_budget/Presentation/Screens/download_record/pdf_viewer.dart';
import 'package:salary_budget/Presentation/Widgets/common_widgets/common_widgets.dart';
import 'package:salary_budget/repository/authenticaion_repository.dart';
import 'dart:developer' as developer;

class ViewRecordController extends GetxController {
  static ViewRecordController get instance => Get.find();
  PDFGeneratorController pdfGeneratorController =
      Get.put(PDFGeneratorController());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var fieldValue = "".obs;
  final List<String> radioOptions = [currentYrRecordsLbl, customYrRecordsLbl];
  RxInt selectedRadio =
      RxInt(0); // Initially selecting the first option (index 0)
  RxBool isLoading = false.obs;
  RxBool isMonthEnabled = true.obs;
  RxBool isYearEnabled = false.obs;
  RxBool isIncomeNull = false.obs;
  RxBool isCurrentSalaryEnteredEnabled = false.obs;
  RxBool isPreviousSalaryEnteredEnabled = false.obs;
  RxBool isMonthYearSelected = false.obs;
  List<double> debitedAmounts = [];
  List<double> creditedAmounts = [];
  var totalDebitedAmount = 0.00.obs;
  var totalCreditedAmount = 0.00.obs;
  var totalBalance = 0.00.obs;

  var monthList = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sept',
    'Oct',
    'Nov',
    'Dec',
  ].obs;
  /*var yearList = [
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
  ].obs;
*/
  RxList<String> yearList = <String>[].obs;

  String user_number = '';
  final currentSalaryController = TextEditingController();
  final customSalaryController = TextEditingController();
  final currentDateMonthController = TextEditingController();
  final currentDateYearController = TextEditingController();
  final customDateMonthController = TextEditingController();
  final customDateYearController = TextEditingController();
  // Get the current year
  int currentYear = DateTime.now().year;
  // Format the current date to display the month name
  String monthName = DateFormat('MMM').format(DateTime.now());
  RxList<Map<String, dynamic>> firestoreData = RxList<Map<String, dynamic>>();
  RxList<dynamic> docIdData = RxList<dynamic>();
  List<ViewRecordTileModel> recordList = <ViewRecordTileModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    user_number = await AuthenticationRepository.instance.loggedUserName();
    generateYearList(5);
    print('year list ${yearList[4]}');
    currentDateYearController.text = currentYear.toString();
    currentDateMonthController.text = monthName.toString();
    checkExistingMonthlyIncome(
        currentDateMonthController.text, currentDateYearController.text);
  }

  void generateYearList(int numberOfYears) {
    int currentYear = DateTime.now().year;

    for (int i = 1; i <= numberOfYears; i++) {
      yearList.add((currentYear - i).toString());
    }
  }

  void changeSelectedValue() {
    if (selectedRadio.value.isEqual(0)) {
      checkExistingMonthlyIncome(
          currentDateMonthController.text, currentDateYearController.text);
      isMonthYearSelected.value = false;
      customDateMonthController.clear();
      customDateYearController.clear();
      customSalaryController.clear();
    } else {
      recordList.clear();
      debitedAmounts.clear();
      creditedAmounts.clear();
      totalDebitedAmount.value = 0.00;
      totalCreditedAmount.value = 0.00;
      totalBalance.value = 0.00;
      fieldValue.value = '';
      checkIncome(fieldValue.value);
    }
  }

  Future<void> checkExistingMonthlyIncome(
      String monthName, String yearNo) async {
    try {
      recordList.clear();
      debitedAmounts.clear();
      creditedAmounts.clear();
      totalDebitedAmount.value = 0.00;
      totalCreditedAmount.value = 0.00;
      totalBalance.value = 0.00;
      if (selectedRadio.value == 0) {
        CollectionReference incomeData = _firestore
            .collection(expensedDataCollectionLbl)
            .doc(user_number)
            .collection(yearNo);
        final DocumentSnapshot document = await incomeData.doc(monthName).get();
        if (document.exists) {
          fieldValue.value = document.get(incomeLbl);
          checkIncome(fieldValue.value);
          await getData(
              expensedDataCollectionLbl, user_number, yearNo, monthName);
        } else {
          fieldValue.value = '';
          isIncomeNull.value = false;
        }
      } else {
        CollectionReference incomeData = _firestore
            .collection(expensedDataCollectionLbl)
            .doc(user_number)
            .collection(yearNo);
        final DocumentSnapshot document = await incomeData.doc(monthName).get();
        if (document.exists) {
          fieldValue.value = document.get(incomeLbl);
          checkIncome(fieldValue.value);
          await getData(
              expensedDataCollectionLbl, user_number, yearNo, monthName);
        } else {
          fieldValue.value = '';
          isIncomeNull.value = false;
        }
      }
    } catch (e) {
      developer.log('exception $e');
    }
  }

  Future<List<ViewRecordTileModel>> getData(
      collectionName, userNumber, year, month) async {
    log('selected year $year $month');
    try {
      isLoading.value = true;
      recordList.clear();
      debitedAmounts.clear();
      creditedAmounts.clear();
      totalDebitedAmount.value = 0.00;
      totalCreditedAmount.value = 0.00;
      totalBalance.value = 0.00;
      CollectionReference expensedData = FirebaseFirestore.instance
          .collection(collectionName)
          .doc(userNumber)
          .collection(year)
          .doc(month)
          .collection(expensedLbl);
      final QuerySnapshot snapshot = await expensedData.get();

      docIdData.assignAll(
        snapshot.docs.map((doc) => doc.id),
      );
      firestoreData.assignAll(
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>),
      );
      // Adding IDs to each map in the list
      for (int i = 0; i < firestoreData.length; i++) {
        firestoreData[i]['docId'] = docIdData[i];
      }
      if (firestoreData.isNotEmpty) {
        for (var data in firestoreData) {
          recordList.add(ViewRecordTileModel(
            docId: data['docId'],
            transDate: data['transaction_date'],
            transParticular: data['particular'],
            transType: data['transaction_type'],
            transAmount: data['amount'],
            transStatus: data['payment_status'],
            transRemarks: data['remarks'],
          ));

          double expensedAmount =
              double.parse(data['amount'].replaceAll(',', ''));
          if (data['transaction_type'] == 'Debit') {
            debitedAmounts.add(expensedAmount);
            totalDebitedAmount.value = totalDebitedMethod(debitedAmounts);
          }
          if (data['transaction_type'] == 'Credit') {
            creditedAmounts.add(expensedAmount);
            totalCreditedAmount.value = totalCreditedMethod(creditedAmounts);
          }
          totalBalance.value = totalBalanceMethod(
              double.tryParse(fieldValue.value),
              totalDebitedAmount.value,
              totalCreditedAmount.value);
        }
        // Sort recordList based on transDate
        recordList.sort((a, b) => a.transDate!.compareTo(b.transDate!));
        isLoading.value = false;
      }
    } catch (e) {
      developer.log('---catch logs${e}');
    }
    return recordList;
  }

  totalDebitedMethod(List<double> debitedAmount) {
    double totalDebited = 0.00;
    for (double amount in debitedAmount) {
      totalDebited += amount;
    }
    return totalDebited;
  }

  totalCreditedMethod(List<double> creditedAmount) {
    double totalCredited = 0.00;
    for (double amount in creditedAmount) {
      totalCredited += amount;
    }
    return totalCredited;
  }

  totalBalanceMethod(
      double? totalIncome, double? totalDebit, double? totalCredit) {
    double totalBalance = 0.00;
    totalBalance = (totalIncome! - totalDebit!) + totalCredit!;
    return totalBalance;
  }

  checkIncome(incomeVal) {
    if (incomeVal == '') {
      isIncomeNull.value = false;
    } else {
      isIncomeNull.value = true;
    }
  }

  confirmToDeleteRecord(BuildContext context, String recordId) async {
    if (selectedRadio.value == 0) {
      log('selected 0 ');
      await deleteRecord(
          context,
          expensedDataCollectionLbl,
          user_number,
          currentDateYearController.text,
          currentDateMonthController.text,
          recordId);
    } else {
      log('selected 1');
      await deleteRecord(
          context,
          expensedDataCollectionLbl,
          user_number,
          customDateYearController.text,
          customDateMonthController.text,
          recordId);
    }
  }

  Future<void> deleteRecord(BuildContext ctx, collectionName, userNumber, year,
      month, documentId) async {
    try {
      WidgetsHelper.onSubmitData(ctx, 'Deleting...');

      // Assuming 'your_collection' is the name of your Firestore collection
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(userNumber)
          .collection(year)
          .doc(month)
          .collection(expensedLbl)
          .doc(documentId)
          .delete();
      // Optionally, you can show a success message or perform other actions
      print('Record deleted successfully');
      await getData(collectionName, userNumber, year, month);
      Navigator.of(ctx).pop();
    } catch (e) {
      // Handle errors
      print('Error deleting record: $e');
      Navigator.of(ctx).pop();
    }
  }

  // Download Transaction Statement
  void downloadStatement(BuildContext ctx) async {
    try {
      File? pdfFile; // Use File? to denote that pdfFile can be null

      if (selectedRadio.value.isEqual(0) ?? false) {
        pdfFile = await pdfGeneratorController.generatePDF(
            ctx,
            user_number,
            currentDateMonthController.text,
            currentDateYearController.text,
            totalDebitedAmount.value,
            totalCreditedAmount.value,
            totalBalance.value,
            recordList);
        log('downloaded path ${pdfFile!.path}');
      } else {
        pdfFile = await pdfGeneratorController.generatePDF(
            ctx,
            user_number,
            customDateMonthController.text,
            customDateYearController.text,
            totalDebitedAmount.value,
            totalCreditedAmount.value,
            totalBalance.value,
            recordList);
      }

      if (pdfFile != null) {
        // File is not null, proceed with further actions
        WidgetsHelper.customSnackbar(
          'File downloaded',
          'Tap to view',
          Colors.green,
          Colors.white,
          3,
          () {
            // Open the PDF file on tap
            Get.to(() => PdfViewer(pdfPath: pdfFile!.path));
          },
        );
      } else {
        // File is null, handle the case where the PDF generation failed
        WidgetsHelper.customSnackbar('Failed to generate PDF',
            'Please try again', Colors.red, Colors.white, 32, () {});
      }
    } catch (err) {
      log('Error occurred in downloadStatement $err');
    }
  }
}
