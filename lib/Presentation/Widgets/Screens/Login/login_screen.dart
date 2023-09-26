import 'package:flutter/material.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Data/Core/Utils/app_decoration.dart';
import 'package:salary_budget/Data/Core/Utils/image_utils.dart';
import 'package:custom_gradient_button/custom_gradient_button.dart';
import 'package:salary_budget/Domain/AppRoutes/routes.dart';
import 'package:salary_budget/Domain/Mixins/form_validation_mixins.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget with InputValidationMixin {
  LoginScreen({super.key});

  final TextEditingController mobileController = TextEditingController();

  final TextEditingController otpController = TextEditingController();

  final loginFormGlobalKey = GlobalKey<FormState>();

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
                      maxLength: 10,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return emptyErrorLbl;
                        } else if (value.length < 10) {
                          return mobileNumberDigitError2Lbl;
                        } else {
                          isMobileNumberValid(value);
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
                method: () {
                  if (loginFormGlobalKey.currentState!.validate()) {
                    loginFormGlobalKey.currentState!.save();
                    //isMobileNumberValid(mobileController.text);
                    print("if part in login");
                    Navigator.pushNamed(context, AppRoutes.otpValidationScreen);
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
