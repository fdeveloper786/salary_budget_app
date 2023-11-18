import 'package:custom_gradient_button/custom_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Data/Core/Utils/app_decoration.dart';
import 'package:salary_budget/Data/Core/Utils/image_utils.dart';
import 'package:salary_budget/Domain/AppRoutes/routes.dart';
import 'package:salary_budget/Domain/Mixins/form_validation_mixins.dart';
import 'package:salary_budget/Presentation/Screens/Login/controller/login_controller.dart';
import 'package:salary_budget/Presentation/Widgets/common_widgets/common_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget with InputValidationMixin {
  LoginScreen({super.key});

  final loginController = Get.put(LoginController());

  final loginFormGlobalKey = GlobalKey<FormState>();
  late final SharedPreferences prefs;
  dynamic setLogs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                      keyboardType: TextInputType.phone,
                      autofocus: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: enterMobileNumberLbl,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fillColor: Colors.white70,
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 10,
                      validator: (value) {
                        String str = value!;
                        if (value!.isEmpty) {
                          return emptyErrorLbl;
                        } else if (str.startsWith('0') ||
                            str.startsWith('1') ||
                            str.startsWith('2') ||
                            str.startsWith('3') ||
                            str.startsWith('4') ||
                            str.startsWith('5')) {
                          return startWithNumberLbl;
                        } else if (value.length < 10) {
                          return mobileNumberDigitError2Lbl;
                        } else {
                          isMobileNumberValid(value);
                        }
                      },
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
                              loginController.phoneAuthentication("+91" +
                                  loginController.phoneController.text.trim());
                              WidgetsHelper.onLoadingPage(context);
                              Future.delayed(const Duration(seconds: 2), () {
                                Navigator.pop(context); //pop dialog
                                Get.toNamed(AppRoutes.otpValidationScreen);
                                //Get.to(() => OTPValidation());
                              });
                            } else {
                              print("else part in login");
                            }
                          },
                        ),
                      ),
                    ),
                    // New Account
                    /* RichText(
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: 'Don\'t have an account ?',
                        style: AppStyle.txtBlack18,
                      ),
                      TextSpan(
                          text: '\tSign Up',
                          style: TextStyle(fontSize: 18, color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('tapp on text');
                            }),
                    ])),
                    const SizedBox(
                      height: 20,
                    ),
                    orWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    // Google button
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              AssetsUtils.googleIconPng,
                              height: 40,
                              width: 40,
                            ),
                            SizedBox(
                                width: 16.0), // Space between icon and text
                            Text('Continue with Google',
                                style: AppStyle.txtBlack18),
                          ],
                        ),
                      ),
                      onTap: () async {
                        await loginController.checkGoogleSignInAuth();
                        WidgetsHelper.onLoadingPage(context);
                        User? user =
                            await loginController.googleAuthentication();
                        WidgetsHelper.onLoadingPage(context);
                        if (user != null) {
                          await AuthenticationRepository.instance
                              .setLoginSession(user.displayName!);
                          print('---signed in with google${user.displayName}');
                          Get.put(HomeController()).displayName.value =
                              user.displayName!;
                          Future.delayed(const Duration(seconds: 2), () {
                            //Navigator.pop(context); //pop dialog
                            Get.off(HomeScreen());
                          });
                        } else {
                          print('----sign in failed');
                        }
                      },
                    ),*/
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget orWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(children: <Widget>[
        Expanded(child: Divider()),
        Text("\t\tOR\t\t"),
        Expanded(child: Divider()),
      ]),
    );
  }
}
