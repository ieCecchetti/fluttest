import 'package:flutter/material.dart';

class ChangingText extends StatelessWidget {

  final String text;

  ChangingText({
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}
