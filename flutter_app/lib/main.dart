import 'package:flutter/material.dart';
import 'package:flutterapp/quiz.dart';
import 'package:flutterapp/result.dart';

import './quiz.dart';

// if the expression do just one thing
void main() => runApp(MyApp());

//rebuilded all the time
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }

}

//state is maintained thanks to the state object
//class MyAppState extends State<MyApp>{  // public class (visible out)
class _MyAppState extends State<MyApp>{   // private class ( ! visible out)

  var _questionIndex = 0;
  var _totalScore = 0;
  final _questions = const [
    {
      'question': 'What\'s your fav color?',
      'answers': [
        {'text':'Black', 'score': 4},
        {'text':'Green', 'score': 2},
        {'text':'Red', 'score': 1},
        {'text':'Blue', 'score': 3}]
    },
    {
      'question': 'What\'s your fav coding language?',
      'answers': [
        {'text':'Java', 'score': 3},
        {'text':'Kotlin', 'score': 2},
        {'text':'cpp', 'score': 4},
        {'text':'C#', 'score': 2}]
    },
    {
      'question': 'Who\'s Steve Jobs?',
      'answers': [
        {'text':'Developer', 'score': 3},
        {'text':'Serial killer', 'score': 1},
        {'text':'CEO apple', 'score': 4},
        {'text':'Microsoft director', 'score': 2}]
    },
  ];

  void _answerQuestion(int score){
    /* set state must encapsulate all the properties that changes
    from a build to another */
    _totalScore += score;
    if (_questionIndex < _questions.length){
      print('we have more questions to show');
    }
    setState(() {
      _questionIndex++;
    });
    print('Answer chosen!');
  }

  void _resetQuiz(){
    setState(() {
      _totalScore = 0;
      _questionIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My first app'),
        ),

        body: _questionIndex < _questions.length
            ? Quiz(
                questions: _questions,
                questionIndex: _questionIndex,
                selectHandler: _answerQuestion
        )
            : Result(_totalScore, _resetQuiz)
      ),
    );
  }
}

