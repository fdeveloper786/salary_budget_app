import 'package:flutter/material.dart';

class AppNavigator {
  static commonNavigator(BuildContext screenContext,Widget screenName) {
    return Navigator.of(screenContext).pushReplacement(MaterialPageRoute(builder: (context)=> screenName));
  }
}