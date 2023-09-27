import 'package:custom_gradient_button/custom_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Data/Core/Utils/app_decoration.dart';
import 'package:salary_budget/Data/Core/Utils/image_utils.dart';
import 'package:salary_budget/Domain/Mixins/form_validation_mixins.dart';
import 'package:salary_budget/Presentation/Widgets/Screens/Login/controller/login_controller.dart';
import 'package:salary_budget/Presentation/Widgets/Screens/Otp_Screen/otp_validation_screen.dart';

class LoginScreen extends StatelessWidget with InputValidationMixin {
  LoginScreen({super.key});

  final loginController = Get.put(LoginController());

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
                      controller: loginController.phoneController,
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
                method: () async {
                  if (loginFormGlobalKey.currentState!.validate()) {
                    loginFormGlobalKey.currentState!.save();
                    print(
                        "input num ${loginController.phoneController.text.trim()}");
                    LoginController.instance.phoneAuthentication(
                        "+91" + loginController.phoneController.text.trim());
                    Get.to(() => OTPValidation());
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
