import 'package:get/get.dart';
import 'package:salary_budget/Presentation/Widgets/Screens/Login/controller/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
