import 'package:get/get.dart';
import 'package:salary_budget/Presentation/Screens/add_record/controller/add_record_controller.dart';
import 'package:salary_budget/Presentation/Screens/view_record/controller/view_controller.dart';

class ViewRecordScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ViewRecordController());
  }
}
