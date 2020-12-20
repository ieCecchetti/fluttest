import 'package:flutter/material.dart';

class TextControl extends StatelessWidget {

  final String btnText;
  final Function handleState;

  TextControl({
    @required this.btnText,
    @required this.handleState,
  });

  @override
  Widget build(BuildContext context) {
    return  RaisedButton(
      child:
      Text(btnText),
      textColor: Colors.blue,
      onPressed: handleState,
    );
  }
}
