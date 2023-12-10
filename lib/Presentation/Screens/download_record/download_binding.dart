import 'package:get/get.dart';
import 'package:salary_budget/Presentation/Screens/download_record/download_record_controller.dart';

class PDFGeneratorControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PDFGeneratorController());
  }
}
