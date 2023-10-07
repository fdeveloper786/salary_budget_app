import 'package:flutter/material.dart';
import 'package:salary_budget/Data/Core/Utils/app_decoration.dart';

class WidgetsHelper {
  // Screen loader
  static void onLoading(context) {
    AlertDialog alertDialog = AlertDialog(
      content: new Row(
        children: <Widget>[
          new CircularProgressIndicator(),
          SizedBox(
            width: 30,
          ),
          new Text("Please Wait..."),
        ],
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => alertDialog,
    );
  }

  static void onLoadingPage(context) {
    AlertDialog alertDialog = AlertDialog(
      content: Row(
        children: <Widget>[
          const CircularProgressIndicator(),
          const SizedBox(
            width: 30,
          ),
          const Text("Please Wait..."),
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

  static void errorAlertBox(context,errorMsg) {
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
            child: Text('Ok',style: AppStyle.txtBlack18,))
      ],
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => alertDialog,
    );
  }
}
