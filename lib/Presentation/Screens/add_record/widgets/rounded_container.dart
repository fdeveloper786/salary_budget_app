import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final String? monthName;
  final monthIncome;

  const RoundedContainer({super.key, this.monthName, this.monthIncome});

  @override
  Widget build(BuildContext context) {
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
          child: Text(
            "$monthName Income :\tINR\t" + monthIncome.toString(),
            style: TextStyle(color: Colors.black87, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
