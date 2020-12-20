import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transactions_list.dart';

import './models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  // DeviceOrientation.portraitUp,
  // DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'Weekly Expenses',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.amber,
            errorColor: Colors.red,
            fontFamily: 'Quicksand',
            textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: TextStyle(
                color: Colors.white,
              ),
            ),
            appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
              ),
            )
          ),
          home: MyHomePage(),
        );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{
  final List<Transaction> _userTransactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      //only last 7 days transaction are passed
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime txDate){
    final newTx = new Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: txDate,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id){
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(context: ctx, builder: (_) {
      //gestureDetector permits to close the popup when tapping outside
      return GestureDetector(
        onTap: () {},
        child: NewTransaction(_addNewTransaction),
        behavior: HitTestBehavior.opaque,
      );
    },);
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery,
      AppBar appBar,
      Widget txListWidget,){
    return [
      Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Show Chart', style: Theme.of(context).textTheme.title,),
        Switch.adaptive(
          activeColor: Theme.of(context).accentColor,
          value: _showChart,
          onChanged: (val) {
            setState(() {
              _showChart = val;
            });
          },
        )
      ],),
      _showChart ? Container(
        height: (mediaQuery.size.height -
            appBar.preferredSize.height -
            mediaQuery.padding.top) * 0.7,
        child: Chart(_recentTransactions),
      ) : txListWidget,
    ];
  }

  List<Widget> _buildPortrateContent(
      MediaQueryData mediaQuery,
      AppBar appBar,
      Widget txListWidget,
      ){
    return [
      Container(
      height: (mediaQuery.size.height -
          appBar.preferredSize.height -
          mediaQuery.padding.top) * 0.3,
      child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  Widget _buildAppBar(){
    return Platform.isIOS ?
    CupertinoNavigationBar(
      middle: Text('Weekly Expenses'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => _startAddNewTransaction(context),
          )
        ],),
    ) : AppBar(
      title: Text('Weekly Expenses'),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = _buildAppBar();
    final txListWidget = Container(
      height: (mediaQuery.size.height -
          appBar.preferredSize.height -
          mediaQuery.padding.top) * 0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    //safeArea is important for  rendering in IOS
    final scaffoldContent = SafeArea(
      child: SingleChildScrollView(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLandscape)
            ..._buildLandscapeContent(
                mediaQuery,
                appBar,
                txListWidget
            ),
          if(!isLandscape)
            //... pull the elements out as single
            ..._buildPortrateContent(
              mediaQuery,
              appBar,
              txListWidget
          ),
        ],
      ),
    ),
    );
    return Platform.isIOS ? CupertinoPageScaffold(
      child: scaffoldContent,
      navigationBar: appBar,
    ) : Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              ..._buildLandscapeContent(
                  mediaQuery,
                  appBar,
                  txListWidget
              ),
            if(!isLandscape)
            //... pull the elements out as single
              ..._buildPortrateContent(
                  mediaQuery,
                  appBar,
                  txListWidget
              ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS ? Container()
          : FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    // start the observer that active the <<didChangeAppLifecycleState>> method
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  // called whenever my lifeCicle Changes (not work without init and dispose)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    print(state);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //its important to remove the observer while disposing
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
