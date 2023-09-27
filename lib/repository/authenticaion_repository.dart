import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:salary_budget/Presentation/Widgets/Screens/Login/login_screen.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  var verificationId = ''.obs;

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
        if (e.code == 'invalid-phone-number') {
          Get.snackbar('Error', 'The provided phone number is not valid.');
          Get.to(() => LoginScreen());
        } else {
          Get.snackbar('Error', 'Something went wrong. Try again..');
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
      Get.snackbar('Error', 'Wrong OTP..');
    }
  }
}
