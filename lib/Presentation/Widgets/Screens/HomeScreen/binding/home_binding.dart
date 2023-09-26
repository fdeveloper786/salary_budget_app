import 'package:get/get.dart';
import 'package:salary_budget/Presentation/Widgets/Screens/HomeScreen/controller/home_controller.dart';

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
