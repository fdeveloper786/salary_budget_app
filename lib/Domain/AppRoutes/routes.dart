import 'package:get/get.dart';
import 'package:salary_budget/Presentation/Screens/HomeScreen/binding/home_binding.dart';
import 'package:salary_budget/Presentation/Screens/HomeScreen/home_screen.dart';
import 'package:salary_budget/Presentation/Screens/Login/binding/login_binding.dart';
import 'package:salary_budget/Presentation/Screens/Login/login_screen.dart';
import 'package:salary_budget/Presentation/Screens/Otp_Screen/binding/otp_binding.dart';
import 'package:salary_budget/Presentation/Screens/Otp_Screen/otp_validation_screen.dart';
import 'package:salary_budget/Presentation/Screens/add_record/binding/add_record_binding.dart';
import 'package:salary_budget/Presentation/Screens/add_record/view/add_record_view.dart';
import 'package:salary_budget/Presentation/Screens/view_record/binding/view_record_binding.dart';
import 'package:salary_budget/Presentation/Screens/view_record/view/view_record_screen.dart';

class AppRoutes {
  static const String initialRoute = "/initialRoute";

  static const String loginScreen = "/login_screen";

  static const String otpValidationScreen = "/otp_validation_screen";

  static const String homeScreen = "/home_screen";

  static const String addRecordScreen = '/add_record_view';

  static const String viewRecordScreen = '/view_record_screen';

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
    GetPage(name: addRecordScreen, page: () => AddRecordScreen(), bindings: [
      AddRecordScreenBinding(),
    ]),
    GetPage(name: viewRecordScreen, page: () => ViewRecordScreen(), bindings: [
      ViewRecordScreenBinding(),
    ]),

  ];
}
