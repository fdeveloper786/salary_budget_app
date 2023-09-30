import 'package:custom_gradient_button/custom_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Data/Core/Utils/app_decoration.dart';
import 'package:salary_budget/Data/Core/Utils/image_utils.dart';
import 'package:salary_budget/Domain/Mixins/form_validation_mixins.dart';
import 'package:salary_budget/Presentation/Screens/Otp_Screen/controller/otp_controller.dart';

class OTPValidation extends StatelessWidget with InputValidationMixin {
  OTPValidation({super.key});

  final otpValidationController = Get.put(OTPController());

  final TextEditingController otpController = TextEditingController();

  final otpFormGlobalKey = GlobalKey<FormState>();

  var code = "";

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
                      //controller: otpController,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      validator: (otp_value) {
                        if (otp_value!.isEmpty) {
                          return otpErrorLbl;
                        } else if (otp_value.length < 6) {
                          return otpLengthLbl;
                        } else {
                          isValidateOtp(otp_value);
                        }
                      },
                      onChanged: (value) {
                        code = value;
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
                  method: () async {
                    otpValidationController.otpVerification(code, context);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
