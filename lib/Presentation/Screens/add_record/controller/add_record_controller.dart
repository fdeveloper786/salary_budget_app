import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:salary_budget/repository/authenticaion_repository.dart';

class AddRecordController extends GetxController {
  static AddRecordController get instance => Get.find();
  String user_number = '';
  RxString selectedYear = ''.obs;
  RxString selectedMonth = ''.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  void submitSalaryForm(String year, String month) async {
    if (addSalaryFormKey.currentState!.validate()) {
      addSalaryFormKey.currentState!.save();
      final documentPath = user_number;
      checkDocuement(documentPath);
    }
  }

  checkPath() async {
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
      });
      expAmountController.clear();
      expTypeController.clear();
      expDateController.clear();
      expParticularController.clear();
      payDateController.clear();
      payStatusController.clear();
    } else {
      print("will show popup : firstly add monthly salary....");
    }
  }

  // check if ID exist
  Future checkDocuement(String docID) async {
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
      });
    } else {
      print("id is really exist");
    }
  }

  // Form submission function
  void submitRecordForm() async {
    if (addRecordFormKey.currentState!.validate()) {
      addRecordFormKey.currentState!.save();
      checkPath();
    }
  }
}
