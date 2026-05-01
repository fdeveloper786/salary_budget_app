import 'package:get/get.dart';
import 'package:salary_budget/Presentation/Screens/dashboard/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
}