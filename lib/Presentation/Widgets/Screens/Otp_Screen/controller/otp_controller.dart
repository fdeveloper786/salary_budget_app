import 'package:get/get.dart';
import 'package:salary_budget/Presentation/Widgets/Screens/HomeScreen/home_screen.dart';
import 'package:salary_budget/repository/authenticaion_repository.dart';

class OTPController extends GetxController {
  static OTPController get instance => Get.find();

  // OTP Verification Method

  void otpVerification(String phoneNo) async {
    var isVerified = await AuthenticationRepository.instance.verifyOTP(phoneNo);
    isVerified ? Get.offAll(const HomeScreen()) : Get.back();
  }
}
