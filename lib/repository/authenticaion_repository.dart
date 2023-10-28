import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Presentation/Screens/Login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  var verificationId = ''.obs;
  late final SharedPreferences prefs;
  RxBool? isLoggedIn = false.obs;
  var isLoggedOut;
  var phoneNumber = ''.obs;
  //var userMobileNumber = ''.obs;
  var displayName = ''.obs;

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

  Future<void> setLoginSession(String userName) async {
    await prefs.setBool(isLoggedLbl, true);
    await prefs.setString('user_name', userName);
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

  Future<String> loggedUserName() async {
    try {
      displayName.value = prefs.getString('user_name')!;
    } catch (e) {
      print('ex $e');
    }
    return displayName.value;
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
    try {
      bool isRemoved = false;
      final User? user = _auth.currentUser;
      if (user != null) {
        await googleSignIn.signOut();
        isRemoved = await prefs.remove('user_name');
      } else {
        isRemoved = await prefs.remove('user_name');
        //Get.off(LoginScreen());
      }
      return isRemoved;
    } catch (e) {
      developer.log('----logoutcatch $e');
    }
  }

  Future<bool?> checkGoogleLogin() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        print('current user is ${user.displayName}');
        return await prefs.setBool(isLoggedLbl, true);
      }
    } catch (e) {
      developer.log('---current user catch----');
    }
  }

  Future<User?> handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;
      storeUserDetails(user!.email!, user!.displayName!);
      developer.log('----google user auth ----$user');
      return user;
    } catch (e) {
      developer.log('---catch google----$e');
      return null;
    }
  }

  //Store username in DB
  storeUserDetails(String uniqueId, String userName) async {
    try {
      final snapShot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uniqueId)
          .get();
      if (!snapShot.exists) {
        await FirebaseFirestore.instance.collection('users').doc(uniqueId).set({
          'username': userName.toString(),
        });
      } else {
        print('username already exists');
      }
    } catch (error) {
      developer.log('---catch error store db---$error');
    }
  }

  Future<dynamic> getUserName(String uniqueId) async {
    try {
      print('---printing3 name');
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(uniqueId).get();
      if (documentSnapshot.exists) {
        displayName = documentSnapshot.get('username');
        developer.log('---user $displayName');
        return displayName;
      }
    } catch (e) {
      developer.log('----catch in getUsername');
    }
  }

  Future<void> logoutGoogle() async {
    await prefs.setBool(isLoggedLbl, false);
    await googleSignIn.signOut();
    Get.off(LoginScreen()); // navigate to your wanted page after logout.
  }
}
