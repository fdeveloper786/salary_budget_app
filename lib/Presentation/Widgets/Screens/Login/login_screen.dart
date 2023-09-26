import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Data/Core/Utils/app_decoration.dart';
import 'package:salary_budget/Data/Core/Utils/image_utils.dart';
import 'package:custom_gradient_button/custom_gradient_button.dart';
import 'package:salary_budget/Domain/AppRoutes/routes.dart';
import 'package:salary_budget/Domain/Mixins/form_validation_mixins.dart';
import 'package:salary_budget/Presentation/Widgets/Screens/Otp_Screen/otp_validation_screen.dart';

class LoginScreen extends StatefulWidget with InputValidationMixin {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController mobileController = TextEditingController();

  final TextEditingController otpController = TextEditingController();

  final loginFormGlobalKey = GlobalKey<FormState>();

  String phone = "";

  void sendOTP(String countryCode, String mobileNumber) async {
    if (kDebugMode) {
      print("number is ${countryCode + mobileNumber}");
    }
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: countryCode + mobileNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void initState() {
    mobileController.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          loginLbl,
          style: AppStyle.txtBlack25,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: loginFormGlobalKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    Image.asset(
                      AssetsUtils.splashScreenJpg,
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: mobileController,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: enterMobileNumberLbl,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        fillColor: Colors.white70,
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      maxLength: 13,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return emptyErrorLbl;
                        } else if (value.length < 10) {
                          return mobileNumberDigitError2Lbl;
                        } else {
                          //isMobileNumberValid(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CustomGradientButton(
                child: const Text(
                  loginLbl,
                  style: AppStyle.txtWhite20,
                ),
                firstColor: Colors.greenAccent,
                secondColor: Colors.blueAccent,
                height: 40.0,
                width: 150.0,
                method: () async {
                  if (loginFormGlobalKey.currentState!.validate()) {
                    loginFormGlobalKey.currentState!.save();
                    if (kDebugMode) {
                      print(mobileController.text + phone);
                    }
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: mobileController.text + phone,
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationId, int? resendToken) {
                        OTPValidation.verifyOtp = verificationId;
                        Navigator.pushNamed(
                            context, AppRoutes.otpValidationScreen);
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                  } else {
                    print("else part in login");
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
