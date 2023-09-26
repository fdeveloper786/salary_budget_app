import 'package:get/get.dart';
import 'package:salary_budget/Presentation/Widgets/Screens/OTP_Screen/controller/otp_controller.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OTPController());
  }
}