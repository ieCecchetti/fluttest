import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int resultScore;
  final Function resetHandler;

  Result(this.resultScore, this.resetHandler);

  String get resultPhrase{
    var resultText = 'Test is finished \n';
    if (resultScore > 3 && resultScore <6){
      resultText += 'Sorry.. You sucks \n';
    }else if  (resultScore > 6 && resultScore <10){
      resultText += 'Not bad man, great score. \n';
    } else {
      resultText += 'You are really awesome! \n';
    }
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            resultPhrase,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          FlatButton(
              child: Text('Restart Quiz!'),
              textColor: Colors.blue,
              onPressed: resetHandler),
        ],
      ),
    );
  }
}
