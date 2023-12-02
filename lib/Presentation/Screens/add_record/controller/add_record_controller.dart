import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Presentation/Widgets/common_widgets/common_widgets.dart';
import 'package:salary_budget/repository/authenticaion_repository.dart';
import 'dart:developer' as developer;

class AddRecordController extends GetxController {
  static AddRecordController get instance => Get.find();
  String user_number = '';
  RxString selectedYear = ''.obs;
  RxString selectedMonth = ''.obs;
  RxBool isMonthEnabled = true.obs;
  RxBool isYearEnabled = false.obs;
  RxBool isCurrentSalaryEnteredEnabled = false.obs;
  RxBool isPreviousSalaryEnteredEnabled = false.obs;

  var fieldValue = ''.obs;
  final List<String> radioOptions = [currentYrIncomeLbl, customYrIncomeLbl];
  RxInt selectedRadio = RxInt(0);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  BuildContext? context;

  final addSalaryFormKey = GlobalKey<FormState>();
  final currentDateFormKey = GlobalKey<FormState>();
  final previousDateFormKey = GlobalKey<FormState>();
  final currAddRecordFormKey = GlobalKey<FormState>();
  final custAddRecordFormKey = GlobalKey<FormState>();

  final currentSalaryController = TextEditingController();
  final customSalaryController = TextEditingController();
  final currentDateMonthController = TextEditingController();
  final currentDateYearController = TextEditingController();
  final customDateMonthController = TextEditingController();
  final customDateYearController = TextEditingController();

  final currAmountController = TextEditingController();
  final currTransTypeController = TextEditingController();
  final currTransDateController = TextEditingController();
  final currTransParticularController = TextEditingController();
  final currRemarksController = TextEditingController();
  final currPayStatusController = TextEditingController();

  final custAmountController = TextEditingController();
  final custTransTypeController = TextEditingController();
  final custTransDateController = TextEditingController();
  final custTransParticularController = TextEditingController();
  final custRemarksController = TextEditingController();
  final custPayStatusController = TextEditingController();

  // Get the current year
  int currentYear = DateTime.now().year;
  // Format the current date to display the month name
  String monthName = DateFormat('MMM').format(DateTime.now());
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

  var yearList = [
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
  ].obs;

  var paymentStatusList = [
    'Fully Paid',
    'Partially Paid',
  ].obs;
  var expTypeList = [
    'Credit',
    'Debit',
  ].obs;

  @override
  void onInit() async {
    super.onInit();
    user_number = await AuthenticationRepository.instance.loggedUserName();
    currentDateYearController.text = currentYear.toString();
    currentDateMonthController.text = monthName.toString();
    checkExistingMonthlyIncome(
        currentDateMonthController.text, currentDateYearController.text);
  }

  void changeSelectedValue() {
    currentDateYearController.text = currentYear.toString();
    currentDateMonthController.text = monthName.toString();
    if (selectedRadio.value.isEqual(0)) {
      checkExistingMonthlyIncome(
          currentDateMonthController.text, currentDateYearController.text);
      clearTextField();
    } else {
      fieldValue.value = '';
      customDateMonthController.clear();
      customDateYearController.clear();
      customSalaryController.clear();
      clearTextField();
    }
  }

  clearTextField() {
    if (selectedRadio.value.isEqual(0)) {
      currAmountController.clear();
      currTransTypeController.clear();
      currTransDateController.clear();
      currTransParticularController.clear();
      currRemarksController.clear();
      currPayStatusController.clear();
    } else {
      // CustomDate controller clear
      custAmountController.clear();
      custTransTypeController.clear();
      custTransDateController.clear();
      custTransParticularController.clear();
      custRemarksController.clear();
      custPayStatusController.clear();
    }
  }

  Future<void> checkExistingMonthlyIncome(
      String monthName, String yearNo) async {
    try {
      if (selectedRadio.value.isEqual(0)) {
        CollectionReference incomeData = _firestore
            .collection('current_year_income_data')
            .doc(user_number)
            .collection(yearNo);
        final DocumentSnapshot document = await incomeData.doc(monthName).get();
        if (document.exists) {
          fieldValue.value = document.get('total_income');
        } else {
          fieldValue.value = '';
        }
      } else {
        CollectionReference incomeData = _firestore
            .collection('custom_year_income_data')
            .doc(user_number)
            .collection(yearNo);
        final DocumentSnapshot document = await incomeData.doc(monthName).get();
        if (document.exists) {
          fieldValue.value = document.get('total_income');
        } else {
          fieldValue.value = '';
        }
      }
    } catch (e) {
      print('exception $e');
    }
  }

  void submitSalaryForm(formKey, String year, String month, ctx) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final documentPath = user_number;
      checkDocument(documentPath, ctx);
    }
  }

// check if ID exist
  checkDocument(String docID, BuildContext ctx) async {
    try {
      if (selectedRadio.value.isEqual(0)) {
        final snapShot = await FirebaseFirestore.instance
            .collection(currentYearCollectionNameLbl)
            .doc(docID)
            .get();
        if (!snapShot.exists) {
          print('id is not exist');
          print("will show adding salary...");
          await FirebaseFirestore.instance
              .collection(currentYearCollectionNameLbl)
              .doc(user_number)
              .collection(currentDateYearController.text)
              .doc('${currentDateMonthController.text}')
              .set({
            'total_income': currentSalaryController.text,
          }).then((result) {
            print("result is ");
            commonSnackbar('Record added', monthlySalaryAddedLbl);
            Future.delayed(Duration(seconds: 2), () {
              checkExistingMonthlyIncome(currentDateMonthController.text,
                  currentDateYearController.text);
              currentSalaryController.clear();
            });
          }).catchError((error) {
            onLoading(ctx, error);
          });
        }
      } else {
        final snapShot = await FirebaseFirestore.instance
            .collection(customYearCollectionNameLbl)
            .doc(docID)
            .get();
        if (!snapShot.exists) {
          print('id is not exist');
          print("will show adding salary...");
          await FirebaseFirestore.instance
              .collection(customYearCollectionNameLbl)
              .doc(user_number)
              .collection(customDateYearController.text)
              .doc('${customDateMonthController.text}')
              .set({
            'total_income': customSalaryController.text,
          }).then((result) {
            print("result is ");
            commonSnackbar('Record added', monthlySalaryAddedLbl);
            Future.delayed(Duration(seconds: 2), () {
              checkExistingMonthlyIncome(customDateMonthController.text,
                  customDateYearController.text);
              customSalaryController.clear();
            });
            //onLoading(ctx, monthlySalaryAddedLbl);
            //isMonthEnabled.value = false;
            // /isYearEnabled.value = false;
            //isSalaryEnteredEnabled.value = false;
          }).catchError((error) {
            onLoading(ctx, error);
          });
        } else {
          print('id exist');
        }
      }
    } catch (e) {
      print('error 3 $e');
    }
  }

  commonSnackbar(String title, String body) {
    Get.snackbar(
      title,
      body,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green[600],
      colorText: Colors.white,
      duration: Duration(seconds: 5),
    );
  }

  checkPath(
    BuildContext ctx,
    String collectionName,
    String monthCollectionName,
    String yearDocName,
    String transPayDate,
    String transParticular,
    String transType,
    String transAmnt,
    String transPayStatus,
    String transRemarks,
  ) async {
    try {
      Map<String, dynamic> initialData = {
        'transaction_date': transPayDate,
        'particular': transParticular,
        'transaction_type': transType,
        'amount': transAmnt,
        'payment_status': transPayStatus,
        'remarks': transRemarks,
      };
      final DocumentSnapshot snapShot = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(user_number)
          .collection(yearDocName)
          .doc(monthCollectionName)
          .get();
      if (snapShot.exists) {
        await snapShot.reference
            .collection(expensedLbl)
            .doc()
            .set(initialData)
            .then((result) {
          onLoading(ctx, recordAddedLbl);
          isMonthEnabled.value = true;
          clearTextField();
        }).catchError((error) {
          onLoading(ctx, error);
        });
      } else {
        onLoading(ctx, monthYearExistanceErrorLbl);
      }
    } catch (e) {
      developer.log(e.toString());
    }
  }

  // Form submission function
  void submitRecordForm(
    BuildContext ctx,
    String collectionName,
    monthCollectionName,
    yearDocName,
    formKey,
    transDateController,
    transPrtController,
    transTypeController,
    transAmntController,
    transStController,
    transRemarksController,
  ) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      checkPath(
        ctx,
        collectionName,
        monthCollectionName,
        yearDocName,
        transDateController,
        transPrtController,
        transTypeController,
        transAmntController,
        transStController,
        transRemarksController,
      );
    }
  }

  // alert popup with circular progress
  void onLoading(BuildContext loaderContext, [String? errorMsg]) async {
    WidgetsHelper.onLoadingPage(loaderContext);
    await Future.delayed(const Duration(seconds: 2), () {
      WidgetsHelper.errorAlertBox(loaderContext, errorMsg);
    });
  }

  @override
  void dispose() {
    super.dispose();
    currentSalaryController.dispose();
    customSalaryController.dispose();
    currentDateMonthController.dispose();
    currentDateYearController.dispose();
    customDateMonthController.dispose();
    customDateYearController.dispose();
    currAmountController.dispose();
    currTransTypeController.dispose();
    currTransDateController.dispose();
    currTransParticularController.dispose();
    currRemarksController.dispose();
    currPayStatusController.dispose();
  }
}
