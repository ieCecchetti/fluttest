import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weeklyexpenses/widgets/chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  //get means dynamic created property
  List<Map<String, Object>> get groupTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index),);
      double totalSum = 0.0;

      for(var i = 0; i<recentTransactions.length; i++){
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year ){
          totalSum += recentTransactions[i].amount;
        }
      }

      // example {day: T, amount: 9.99}
      return {'day': DateFormat.E().format(weekDay).substring(0,1), 'amount': totalSum};
    }).reversed.toList();
  }

  double get totalSpending{
    return groupTransactionValues.fold(0.0, (sum, next) {
      return sum + next['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupTransactionValues.map((e) {
            //flexible flex every item to have the sam,e characteristics
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  e['day'],
                  e['amount'],
                  totalSpending == 0.0 ? 0.0 : (e['amount'] as double)/totalSpending
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
