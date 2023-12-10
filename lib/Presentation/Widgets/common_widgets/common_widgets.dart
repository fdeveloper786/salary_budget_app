import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salary_budget/Data/Core/Utils/app_decoration.dart';

class WidgetsHelper {

  static void customSnackbar(
      String message,
      String actionMessage,
      Color backgroundColor,
      Color textColor,
      int duration,
      VoidCallback onTap,
      ) {
    Get.snackbar(
      message,
      '',
      backgroundColor: backgroundColor,
      colorText: textColor,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: duration),
      mainButton: TextButton(
        onPressed: onTap,
        child: Text(actionMessage,style: TextStyle(color: Colors.white,fontSize: 16),),
      ),
    );
  }
  // Screen loader
  static void onLoading(context,[String? msg]) {
    AlertDialog alertDialog = AlertDialog(
      content: new Row(
        children: <Widget>[
          new CircularProgressIndicator(),
          SizedBox(
            width: 30,
          ),
          new Text(msg ?? "Please Wait..."),
        ],
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => alertDialog,
    );
  }

  static void onLoadingPage(context, [String? msg]) {
    AlertDialog alertDialog = AlertDialog(
      content: Row(
        children: <Widget>[
          const CircularProgressIndicator(),
          const SizedBox(
            width: 30,
          ),
          Text(msg ?? 'Please wait...'),
        ],
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => alertDialog,
    );
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); //pop dialog
    });
  }

  static void onSubmitData(context, [String? msg]) {
    AlertDialog alertDialog = AlertDialog(
      content: Row(
        children: <Widget>[
          const CircularProgressIndicator(),
          const SizedBox(
            width: 30,
          ),
          Text(msg ?? 'Please wait...'),
        ],
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => alertDialog,
    );
  }

  static void errorAlertBox(context, errorMsg) {
    AlertDialog alertDialog = AlertDialog(
      content: Container(
        height: 50,
        child: Center(
          child: Text(
            errorMsg,
            style: AppStyle.txtBlack20,
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              // Close the alert dialog
              Navigator.of(context).pop();
            },
            child: Text(
              'Ok',
              style: AppStyle.txtBlack18,
            ))
      ],
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => alertDialog,
    );
  }
}
