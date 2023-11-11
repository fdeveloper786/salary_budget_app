import 'package:get/get.dart';
import 'package:salary_budget/Presentation/Screens/update_record/controller/update_controller.dart';

class UpdateControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdateRecordController());
  }
}
