import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Presentation/Screens/Login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  var verificationId = ''.obs;
  late final SharedPreferences prefs;
  RxBool? isLoggedIn = false.obs;
  var isLoggedOut;
  var phoneNumber = ''.obs;
  var userMobileNumber = ''.obs;

  // OTP Login
  Future<void> phoneAuthentication(String mobileNumber) async {
    phoneNumber.value = mobileNumber.substring(3);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: mobileNumber,
      verificationCompleted: (credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      codeSent: (verificationId, resendToken) {
        this.verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        this.verificationId.value = verificationId;
      },
      verificationFailed: (e) {
        if (e.code == invalidPhoneNumberLbl) {
          Get.snackbar(errorLbl, invalidNumberLbl);
          Get.to(() => LoginScreen());
        } else {
          Get.snackbar(errorLbl, somethingWentWrongLbl);
          Get.to(() => LoginScreen());
        }
      },
    );
  }

  // Verify OTP
  Future<bool?> verifyOTP(String otp) async {
    var credentials;
    try {
      credentials = await FirebaseAuth.instance.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: verificationId.value, smsCode: otp));
      return credentials.user != null ? true : false;
    } on FirebaseAuthException catch (e) {
      print("Failed otp $e");
      Get.snackbar(errorLbl, wrongOtpLbl);
    }
  }

  // Check user is logged in o rnot

  Future<void> setLoginSession(mobileNo) async {
    await prefs.setBool(isLoggedLbl, true);
    await prefs.setString('mobile_number', mobileNo);
  }

  Future<bool?> isUserLoggedIn() async {
    try {
      prefs = await SharedPreferences.getInstance();
      isLoggedIn!.value = prefs.getBool(isLoggedLbl)!;
    } catch (e) {
      print("exception $e");
    }
    return isLoggedIn!.value;
  }

  Future<String> userLoggedNumber() async {
    try {
      userMobileNumber.value = prefs.getString('mobile_number')!;
    } catch (e) {
      print('ex $e');
    }
    return userMobileNumber.value;
  }

  Future<bool?> userLoggedOut() async {
    try {
      isLoggedOut = await prefs.remove(isLoggedLbl);
    } catch (e) {
      print('exception $e');
    }
    return isLoggedOut;
  }

  Future<bool?> removedUserName() async {
    bool isRemoved = await prefs.remove('mobile_number');
    return isRemoved;
  }
}
