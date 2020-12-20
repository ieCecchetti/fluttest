import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteHandler,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteHandler;

  @override
  State<StatefulWidget> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem>{
  Color _bgColor;

  @override
  void initState() {
    const availableColors = [Colors.red, Colors.green, Colors.blue, Colors.purple];

    _bgColor = availableColors[Random().nextInt(availableColors.length)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
            radius: 30,
            backgroundColor: _bgColor,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: FittedBox(
                child: Text('\$${widget.transaction.amount}'),
              ),
            )),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ?
        //render icon + text
        FlatButton.icon(
          textColor: Theme.of(context).errorColor,
          onPressed: () {},
          icon: const Icon(Icons.delete),
          label: const Text('Delete'),
        )
            : IconButton(
          //just icon
          icon: const Icon(Icons.delete),
          color: Theme.of(context).errorColor,
          onPressed: () => widget.deleteHandler(widget.transaction.id),
        ),
      ),
    );
  }
}
