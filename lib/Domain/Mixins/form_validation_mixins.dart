import 'package:salary_budget/Data/Core/Utils/app_constants.dart';

mixin InputValidationMixin {
  // Mobile Number Validation
  bool isMobileNumberValid(String inputNumber) {
    Pattern pattern = r'^([0-9])';
    RegExp regExp = RegExp(pattern.toString());
    return regExp.hasMatch(inputNumber);
  }
  bool isValidateOtp(String inputOtp){
    Pattern pattern = r'^([0-9])';
    RegExp regExp = RegExp(pattern.toString());
    return regExp.hasMatch(inputOtp);
  }

}
