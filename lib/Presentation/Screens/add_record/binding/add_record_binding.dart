import 'package:get/get.dart';
import 'package:salary_budget/Presentation/Screens/add_record/controller/add_record_controller.dart';

class AddRecordScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddRecordController());
  }
}
