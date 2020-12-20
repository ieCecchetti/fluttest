import 'package:flutter/material.dart';
import 'package:textcontrol/changing_text.dart';
import 'package:textcontrol/text_control.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{

  var _state = 0;

  final Map<int, String> _changingText = const {
    0: 'Press the button for unlock the content',
    1: 'The reader is stupid.'
  };

  final Map<int, String> _changingButton = const {
    0: 'Tap to Unlock',
    1: 'Tap to Hide'
  };

  void _unlockText(){
    setState(() {
      _state == 0 ? _state = 1 : _state = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('myTestApplication'),
        ),

        body: Container(
          width: double.infinity,
          margin: EdgeInsets.all(16),
          child:
            Column(
              children: [
                ChangingText(text: _changingText[_state],),
                TextControl(
                  btnText: _changingButton[_state],
                  handleState: _unlockText,
                ),
              ],
            )
        )
      ),
    );
  }

}
