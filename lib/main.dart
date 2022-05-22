import 'package:expenses_app/widgets/new_transaction.dart';
import 'package:expenses_app/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/transaction.dart';
import 'widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.purple)
            .copyWith(
            secondary: Colors.amber),
        fontFamily: 'Quicksand',
        appBarTheme: const AppBarTheme(titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,)),
        textTheme: ThemeData.light().textTheme.copyWith(
          subtitle1: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ) ,
          subtitle2: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ) ,
        ),
      ),
      home: const MyHomePage()
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions{
    return _userTransactions.where(
        (tx)  {return tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));}
    ).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime dateTime)
  {
    final newTx = Transaction(DateTime.now().toString(), title, amount, dateTime);
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id)
  {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void startNewTransaction(BuildContext ctx)
  {
    showModalBottomSheet(
        context: ctx,
        builder: (_)
        {
          return GestureDetector(
              onTap: (){},
              child: NewTransaction(
                  addNewTransaction: _addNewTransaction),
              behavior: HitTestBehavior.opaque,
          );
    });
  }
  
  @override
  Widget build(BuildContext context) {

    bool _isLandScape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    AppBar appBar = AppBar(
      title: const Text("Personal Expenses"),
      elevation: 5,
    );

    Widget _transactionList =  SizedBox(
        height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.7,
        child: TransactionList(transactions: _userTransactions, deleteTransaction: _deleteTransaction,));

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if(_isLandScape) Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Switch(value: _showChart, onChanged: (value){
                  setState(() => _showChart = value);}),
              ],
            ),
            
            if(_isLandScape)_showChart ? SizedBox(
                height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.7,
                child: Chart(recentTransactions: _recentTransactions,)) : _transactionList,
            if(!_isLandScape)
              SizedBox(
                  height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.3,
                  child: Chart(recentTransactions: _recentTransactions,)),
            if(!_isLandScape) _transactionList,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          startNewTransaction(context);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

