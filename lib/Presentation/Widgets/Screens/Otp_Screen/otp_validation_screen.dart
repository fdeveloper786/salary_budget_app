import 'package:custom_gradient_button/custom_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Data/Core/Utils/app_decoration.dart';
import 'package:salary_budget/Data/Core/Utils/image_utils.dart';
import 'package:salary_budget/Domain/AppRoutes/routes.dart';
import 'package:salary_budget/Domain/Mixins/form_validation_mixins.dart';

class OTPValidation extends StatelessWidget with InputValidationMixin {
  OTPValidation({super.key});
  static String verifyOtp = "";

  final TextEditingController otpController = TextEditingController();

  final otpFormGlobalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          otpValidationLbl,
          style: AppStyle.txtBlack25,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: otpFormGlobalKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      AssetsUtils.otpVerificationJpg,
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Pinput(
                      length: 6,
                      showCursor: true,
                      controller: otpController,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return otpErrorLbl;
                        } else if (value.length < 6) {
                          return otpLengthLbl;
                        } else {
                          isValidateOtp(value);
                        }
                      },
                      onChanged: (value) {
                        print('otp value is $value');
                        //code = value;
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
                  validateLbl,
                  style: AppStyle.txtWhite20,
                ),
                firstColor: Colors.greenAccent,
                secondColor: Colors.blueAccent,
                height: 40.0,
                width: 150.0,
                method: () {
                  if (otpFormGlobalKey.currentState!.validate()) {
                    otpFormGlobalKey.currentState!.save();
                    //isMobileNumberValid(mobileController.text);
                    print("if part in otp");
                    Navigator.pushNamed(context, AppRoutes.homeScreen);
                  } else {
                    print("else part in otp");
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
