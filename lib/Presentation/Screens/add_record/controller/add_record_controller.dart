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

  final expAmountController = TextEditingController();
  final expTypeController = TextEditingController();
  final expDateController = TextEditingController();
  final expParticularController = TextEditingController();
  final payDateController = TextEditingController();
  final payStatusController = TextEditingController();

  final custExpAmountController = TextEditingController();
  final custExpTypeController = TextEditingController();
  final custExpDateController = TextEditingController();
  final custExpParticularController = TextEditingController();
  final custPayDateController = TextEditingController();
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
    'Borrow',
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
      expAmountController.clear();
      expTypeController.clear();
      expDateController.clear();
      expParticularController.clear();
      payDateController.clear();
      payStatusController.clear();
    } else {
      // CustomDate controller clear
      custExpAmountController.clear();
      custExpTypeController.clear();
      custExpDateController.clear();
      custExpParticularController.clear();
      custPayDateController.clear();
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
      String expAmnt,
      String expType,
      String expDate,
      String expParticular,
      String payDate,
      String payStatus) async {
    try {
      final DocumentSnapshot snapShot = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(user_number)
          .collection(yearDocName)
          .doc(monthCollectionName)
          .get();

      if (snapShot.exists) {
        await snapShot.reference.collection(expensedLbl).doc().set({
          'expensed_amount': expAmnt, //'30 Sept 2023',
          'expensed_type': expType,
          'expensed_date': expDate,
          'expensed_particular': expParticular,
          'payment_date': payDate,
          'payment_status': payStatus,
        }).then((result) {
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
      expAmntController,
      expTypeController,
      expDateController,
      expPrtController,
      expPayDtController,
      expStController) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      checkPath(
          ctx,
          collectionName,
          monthCollectionName,
          yearDocName,
          expAmntController,
          expTypeController,
          expDateController,
          expPrtController,
          expPayDtController,
          expStController);
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
    expAmountController.dispose();
    expTypeController.dispose();
    expDateController.dispose();
    expParticularController.dispose();
    payDateController.dispose();
    payStatusController.dispose();
  }
}
