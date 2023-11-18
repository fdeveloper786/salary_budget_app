import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final String? text;
  final String? value;
  final TextStyle? textStyle;
  final TextStyle? valueStyle;

  const CustomRichText(
      {super.key, this.text, this.value, this.textStyle, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(text: text, style: textStyle),
              TextSpan(text: value, style: valueStyle),
            ]));
  }
}