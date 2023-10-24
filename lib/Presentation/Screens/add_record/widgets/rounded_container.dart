import 'package:flutter/material.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Data/Core/Utils/app_decoration.dart';
import 'package:salary_budget/Domain/extensions/extensions.dart';

class RoundedContainer extends StatelessWidget {
  final String? monthName;
  final monthIncome;

  const RoundedContainer({super.key, this.monthName, this.monthIncome});

  @override
  Widget build(BuildContext context) {
    final incomeValue = double.tryParse(monthIncome)!
        .toStringAsFixed(2)
        .formatAsCurrency(); //monthIncome;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.black,
              width: 0.7), // Adjust the value to control the roundness
        ),
        child: Center(
            child: /* Text(
            "$monthName Income :\t$indianRupeeSymbol\t" + monthIncome.toString(),
            style: TextStyle(color: Colors.black87, fontSize: 20),
          ),*/
                RichText(
          text: TextSpan(children: <TextSpan>[
            TextSpan(
                text: "$monthName Income :",
                style: TextStyle(color: Colors.black87, fontSize: 20)),
            TextSpan(text: "\t$incomeValue", style: AppStyle.txtBlack20),
          ]),
        )),
      ),
    );
  }
}
