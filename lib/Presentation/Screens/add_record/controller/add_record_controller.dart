import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  RxBool isSalaryEnteredEnabled = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  BuildContext? context;

  final addSalaryFormKey = GlobalKey<FormState>();
  final addRecordFormKey = GlobalKey<FormState>();

  final salaryController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();
  final expAmountController = TextEditingController();
  final expTypeController = TextEditingController();
  final expDateController = TextEditingController();
  final expParticularController = TextEditingController();
  final payDateController = TextEditingController();
  final payStatusController = TextEditingController();

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
  }

  void submitSalaryForm(String year, String month, ctx) async {
    if (addSalaryFormKey.currentState!.validate()) {
      addSalaryFormKey.currentState!.save();
      final documentPath = user_number;
      checkDocument(documentPath, ctx);
    }
  }

// check if ID exist
  checkDocument(String docID, BuildContext ctx) async {
    try {
      final snapShot = await FirebaseFirestore.instance
          .collection('salary_data')
          .doc(docID)
          .get();
      if (snapShot == null || !snapShot.exists) {
        print('id is not exist');
        print("will show adding salary...");
        await FirebaseFirestore.instance
            .collection('salary_data')
            .doc(user_number)
            .collection(yearController.text)
            .doc('${monthController.text}_salary')
            .set({
          '${monthController.text}_salary': salaryController.text,
        }).then((result) {
          print("result is ");
          onLoading(ctx, monthlySalaryAddedLbl);
          //isMonthEnabled.value = false;
          // /isYearEnabled.value = false;
          //isSalaryEnteredEnabled.value = false;
        }).catchError((error) {
          onLoading(ctx, error);
        });
      } else {
        print("id is really exist");
      }
    } catch (e) {
      print('error 3 $e');
    }
  }

  checkPath(BuildContext ctx) async {
    try {
      final DocumentSnapshot snapShot = await FirebaseFirestore.instance
          .collection('salary_data')
          .doc(user_number)
          .collection(yearController.text)
          .doc('${monthController.text}_salary')
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
