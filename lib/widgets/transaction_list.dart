import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {

  final List<Transaction> transactions;
  final Function deleteTransaction;

  TransactionList({required this.transactions, required this.deleteTransaction});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      child: transactions.isEmpty? LayoutBuilder(builder: (ctx,constraints) {
        return Column(children: [
          const Text('No transactions added yet!'),
          const SizedBox(height: 10),
          SizedBox(
              height: constraints.maxHeight * 0.6,
              child: Image.asset("assets/waiting.png",
                fit: BoxFit.cover,))
        ],);
      })
       : ListView.builder(
        itemBuilder:(ctx,index)
        {
          return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 5,
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: 30,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: FittedBox(
                      child: Text('\$${transactions[index].amount}',
                      style: const TextStyle(
                        color: Colors.white
                      ),),
                    ),
                  ),
              ),
              title: Text(
                transactions[index].title,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              subtitle: Text(
                DateFormat.yMMMd().format(transactions[index].date)
              ),
              trailing:
              MediaQuery.of(context).size.width > 360 ?
                  TextButton.icon(
                      onPressed:  () {
                        deleteTransaction(transactions[index].id);
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Theme.of(context).errorColor)
                  )
                    ,)
                  :
              IconButton(icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  deleteTransaction(transactions[index].id);
                },),
            ),
          );

        },
        itemCount: transactions.length,

      ),
    );
  }
}
