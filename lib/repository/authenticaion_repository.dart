import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Presentation/Widgets/Screens/Login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  var verificationId = ''.obs;
  late final SharedPreferences prefs;
  RxBool? isLoggedIn = false.obs;
  var isLoggedOut;

  // OTP Login
  Future<void> phoneAuthentication(String mobileNumber) async {
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
          //Get.back();
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

  Future<void> setLoginSession() async {
    //prefs = await SharedPreferences.getInstance();
    var setLogs = await prefs.setBool(isLoggedLbl, true);

    print("setlogs $setLogs");
  }

  Future<bool?> isUserLoggedIn() async {
    try {
      prefs = await SharedPreferences.getInstance();
      isLoggedIn!.value = prefs.getBool(isLoggedLbl)!;
      print("logged in $isLoggedIn");
    } catch (e) {
      print("exception $e");
    }
    return isLoggedIn!.value;
  }

  Future<bool?> userLoggedOut() async {
    try {
      isLoggedOut = await prefs.remove(isLoggedLbl);
      print("logged out $isLoggedOut ${isLoggedOut.runtimeType}");
    } catch (e) {
      print('exception $e');
    }
    return isLoggedOut;
  }
}
