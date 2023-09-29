import 'package:get/get.dart';
import 'package:salary_budget/Presentation/Widgets/Screens/HomeScreen/binding/home_binding.dart';
import 'package:salary_budget/Presentation/Widgets/Screens/HomeScreen/home_screen.dart';
import 'package:salary_budget/Presentation/Widgets/Screens/Login/binding/login_binding.dart';
import 'package:salary_budget/Presentation/Widgets/Screens/Login/login_screen.dart';
import 'package:salary_budget/Presentation/Widgets/Screens/OTP_Screen/binding/otp_binding.dart';
import 'package:salary_budget/Presentation/Widgets/Screens/OTP_Screen/otp_validation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRoutes {
  static const String initialRoute = "/initialRoute";

  static const String loginScreen = "/login_screen";

  static const String otpValidationScreen = "/otp_validation_screen";

  static const String homeScreen = "/home_screen";
  static const String navBarScreen = "/nav_bar_screen";

  static List<GetPage> pages = [
    GetPage(name: loginScreen, page: () => LoginScreen(), bindings: [
      LoginBinding(),
    ]),
    GetPage(name: initialRoute, page: () => LoginScreen(), bindings: [
      LoginBinding(),
    ]),
    GetPage(name: otpValidationScreen, page: () => OTPValidation(), bindings: [
      OtpBinding(),
    ]),
    GetPage(name: homeScreen, page: () => HomeScreen(), bindings: [
      HomeScreenBinding(),
    ]),
  ];
}
