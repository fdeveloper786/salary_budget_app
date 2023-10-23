import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Presentation/Widgets/common_widgets/common_widgets.dart';
import 'package:salary_budget/repository/authenticaion_repository.dart';

class AddRecordController extends GetxController {
  static AddRecordController get instance => Get.find();
  String user_number = '';
  RxString selectedYear = ''.obs;
  RxString selectedMonth = ''.obs;
  RxBool isMonthEnabled = true.obs;
  RxBool isYearEnabled = false.obs;
  RxBool isCurrentSalaryEnteredEnabled = false.obs;
  RxBool isPreviousSalaryEnteredEnabled = false.obs;
  var selectedValue = 'Current Date'.obs;
  var radioButtonIndex = 1.obs;
  var fieldValue = ''.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  BuildContext? context;

  final addSalaryFormKey = GlobalKey<FormState>();
  final currentDateFormKey = GlobalKey<FormState>();
  final previousDateFormKey = GlobalKey<FormState>();
  final addRecordFormKey = GlobalKey<FormState>();

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
    '2023',
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
    // TODO: implement onInit
    super.onInit();
    user_number = await AuthenticationRepository.instance.userLoggedNumber();
    currentDateYearController.text = currentYear.toString();
    currentDateMonthController.text = monthName.toString();
    checkExistingMonthlyIncome(
        currentDateMonthController.text, currentDateYearController.text);
  }

  void changeSelectedValue(String value, dynamic radioIndex) {
    selectedValue.value = value;
    radioButtonIndex.value = radioIndex;
    print('radio index is ${radioButtonIndex.value}');
    currentDateYearController.text = currentYear.toString();
    currentDateMonthController.text = monthName.toString();
    if (radioButtonIndex.value.isEqual(1)) {
      checkExistingMonthlyIncome(
          currentDateMonthController.text, currentDateYearController.text);
    } else {
      fieldValue.value = '';
      customDateMonthController.clear();
      customDateYearController.clear();
      customSalaryController.clear();
    }
  }

  Future<void> checkExistingMonthlyIncome(
      String monthName, String yearNo) async {
    print('---current month ${monthName} $yearNo');
    try {
      if (radioButtonIndex.value == 1) {
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
      if (radioButtonIndex.value == 1) {
        final snapShot = await FirebaseFirestore.instance
            .collection('current_year_income_data')
            .doc(docID)
            .get();
        if (!snapShot.exists) {
          print('id is not exist');
          print("will show adding salary...");
          await FirebaseFirestore.instance
              .collection('current_year_income_data')
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
            .collection('custom_year_income_data')
            .doc(docID)
            .get();
        if (!snapShot.exists) {
          print('id is not exist');
          print("will show adding salary...");
          await FirebaseFirestore.instance
              .collection('custom_year_income_data')
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

  checkPath(BuildContext ctx) async {
    try {
      if (radioButtonIndex.value == 1) {
        final DocumentSnapshot snapShot = await FirebaseFirestore.instance
            .collection('current_year_income_data')
            .doc(user_number)
            .collection(currentDateYearController.text)
            .doc(currentDateMonthController.text)
            .get();
        if (snapShot.exists) {
          await snapShot.reference.collection('Expensed').doc().set({
            'expensed_amount': expAmountController.text, //'30 Sept 2023',
            'expensed_type': expTypeController.text,
            'expensed_date': expDateController.text,
            'expensed_particular': expParticularController.text,
            'payment_date': payDateController.text,
            'payment_status': payStatusController.text,
          }).then((result) {
            onLoading(ctx, recordAddedLbl);
            expAmountController.clear();
            expTypeController.clear();
            expDateController.clear();
            expParticularController.clear();
            payDateController.clear();
            payStatusController.clear();
            isMonthEnabled.value = true;
          }).catchError((error) {
            onLoading(ctx, error);
          });
        } else {
          onLoading(ctx, monthYearExistanceErrorLbl);
        }
      } else {
        final DocumentSnapshot snapShot = await FirebaseFirestore.instance
            .collection('custom_year_income_data')
            .doc(user_number)
            .collection(customDateYearController.text)
            .doc(customDateMonthController.text)
            .get();
        if (snapShot.exists) {
          await snapShot.reference.collection('Expensed').doc().set({
            'expensed_amount': expAmountController.text, //'30 Sept 2023',
            'expensed_type': expTypeController.text,
            'expensed_date': expDateController.text,
            'expensed_particular': expParticularController.text,
            'payment_date': payDateController.text,
            'payment_status': payStatusController.text,
          }).then((result) {
            onLoading(ctx, recordAddedLbl);
            expAmountController.clear();
            expTypeController.clear();
            expDateController.clear();
            expParticularController.clear();
            payDateController.clear();
            payStatusController.clear();
            isMonthEnabled.value = true;
          }).catchError((error) {
            onLoading(ctx, error);
          });
        } else {
          onLoading(ctx, monthYearExistanceErrorLbl);
        }
      }
    } catch (e) {
      print("helo error");
    }
  }

  // Form submission function
  void submitRecordForm(BuildContext ctx) async {
    if (addRecordFormKey.currentState!.validate()) {
      addRecordFormKey.currentState!.save();
      checkPath(ctx);
    }
  }

  // alert popup with circular progress
  void onLoading(BuildContext loaderContext, [String? errorMsg]) async {
    WidgetsHelper.onLoadingPage(loaderContext);
    await Future.delayed(const Duration(seconds: 2), () {
      WidgetsHelper.errorAlertBox(loaderContext, errorMsg);
    });
  }

  void clearText() {}
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
