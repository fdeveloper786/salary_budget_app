import 'package:custom_gradient_button/custom_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:salary_budget/Data/Core/Utils/app_decoration.dart';

class ScreenButtons extends StatelessWidget {
  final String? btnLabel;
  Function? onTap;

  ScreenButtons({super.key, this.btnLabel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomGradientButton(
        child: Text(
          btnLabel!,
          style: AppStyle.txtWhite20,
        ),
        height: 50.0,
        width: 250.0,
        firstColor: Colors.greenAccent,
        secondColor: Colors.blueAccent,
        method: onTap,
      ),
    );
  }
}
