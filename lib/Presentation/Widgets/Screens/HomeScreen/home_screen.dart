import 'package:flutter/material.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(homeScreenTitleLbl),
      ),
      body: Center(
        child: Column(
          children: [Text('helo home screen')],
        ),
      ),
    );
  }
}
