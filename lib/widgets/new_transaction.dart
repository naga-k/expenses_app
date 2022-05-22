import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTransaction;

  NewTransaction({Key? key, required this.addNewTransaction}) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;

  final FocusNode _amountNodeFocus = FocusNode();

  void _presentDatePicker() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime.now(),
    ).then((value){
      if(value != null)
        {
          setState(()
              {
                _selectedDate = value;
              }
          );
        }

    });
  }

  void _submitData(String val) {

    String title = _titleController.text;
    if( double.tryParse(_amountController.text) != null)
    {
      double amount = double.parse(_amountController.text);
          if(title.isNotEmpty && amount>0 &&_selectedDate != null)
            {
              widget.addNewTransaction(title,amount,_selectedDate!);
              Navigator.of(context).pop();
            }
    }
  }

  void _submitAmount(String val){
    if(_amountController.text != "" && _selectedDate == null)
      {
        _presentDatePicker();
      }
    else
      {
        _submitData(val);
      }
  }

  void _changeFocusToAmount(String val)
  {
    if(_titleController.text.isNotEmpty)
      {
        _amountNodeFocus.requestFocus();
      }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  decoration: const InputDecoration(
                      labelText: 'Title'
                  ),
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  onSubmitted: (_) => _changeFocusToAmount(_),
                ),
                TextField(
                  decoration: const InputDecoration(
                      labelText: 'Amount'
                  ),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _submitAmount(_),
                  focusNode: _amountNodeFocus,
                ),
                SizedBox(
                  height: 70,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(_selectedDate == null ? 'No Date Chosen!' :
                        "Picked Date: ${DateFormat.yMd().format(_selectedDate!)}",),
                      ),
                      TextButton(
                          onPressed: (){
                            _presentDatePicker();
                          },
                          child: const Text('Choose Date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),),),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _submitData("_"),
                  child: Text(
                    'Add Transaction',
                    style: Theme.of(context).textTheme.subtitle2
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
