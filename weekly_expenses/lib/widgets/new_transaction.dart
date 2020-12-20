import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weeklyexpenses/widgets/adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function buttonHandler;

  NewTransaction(this.buttonHandler){
    print('constructor NewTransaction_Widget');
  }

  @override
  _NewTransactionState createState() {
    print('called createState_Widget');
    _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectDate;

  _NewTransactionState(){
    print('constructor NewTransaction_State');
  }

  void _submitData(){
    if (_amountController.text.isEmpty){
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if(enteredTitle.isEmpty || enteredAmount <= 0 || _selectDate == null){
      return;
    }

    widget.buttonHandler(
        enteredTitle,
        enteredAmount,
        _selectDate,
    );

    Navigator.of(context).pop();
  }

  void _showDatePicker(){
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime.now()
    ).then((pickedDate) {
      if(pickedDate == null){
        return;
      }
      setState(() {
        _selectDate = pickedDate;
      });
    });
  }

  //used once at the widget creation
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('initstate_ NewTransaction_State');
  }

  //used every time there is a setState
  @override
  void didUpdateWidget(NewTransaction oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('didUpdate_ NewTransaction_State');
  }

  //while closed - not in the screen anymore
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('dispose_ NewTransaction_State');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                controller: _amountController,
                onSubmitted: (_) => _submitData,
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child:
                      Text(
                          _selectDate == null ? 'No date chosen'
                              : 'Picked date: ${DateFormat.yMd().format(_selectDate)}'
                      ),
                    ),
                    AdaptiveFlatButton("Chose Date", _showDatePicker)
                  ],
                ),
              ),
              RaisedButton(
                child: const Text('Insert'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).buttonColor,
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
