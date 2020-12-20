import 'package:flutter/material.dart';
import 'package:weeklyexpenses/widgets/transaction_item.dart';

import 'package:intl/intl.dart';
import 'package:weeklyexpenses/widgets/transaction_card.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteHandler;

  TransactionList(this.transactions, this.deleteHandler);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: [
                  Text(
                    'No Transaction to show yet!',
                    style: Theme.of(context).textTheme.title,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/noContentToShow.PNG',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        :ListView(
        children: [
          ...transactions.map((tx) => TransactionItem(
            //key: UniqueKey(), this change the key randomly every time
            key: ValueKey(tx.id),
            transaction: tx,
            deleteHandler: deleteHandler,
          )).toList()
        ],);

        /*with builder
        : ListView.builder(
            itemBuilder: (ctx, index) {
              // return TransactionCard(transactions[index]);
              // OR
              return TransactionItem(
                  transaction: transactions[index],
                  deleteHandler: deleteHandler
              );
            },
            itemCount: transactions.length,
          );
         */
  }
}
