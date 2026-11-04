import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/expense_model.dart';
import '../providers/main_provider.dart';

class AddExpenseDialog extends StatefulWidget {
  const AddExpenseDialog({super.key, this.expenseModel});
  final ExpenseModel? expenseModel;

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  Category selectedCategory = Category.food;
  DateTime selectedDateTime = DateTime.now();
  @override
  void initState() {
    if (widget.expenseModel != null) {
      amountController.text = widget.expenseModel!.amount.toString();
      noteController.text = widget.expenseModel!.note.toString();
      selectedCategory = widget.expenseModel!.category;
      selectedDateTime = widget.expenseModel!.timeStamp;
    }
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          selectedDateTime.hour,
          selectedDateTime.minute,
        );
      });
    }
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );

    if (time != null) {
      setState(() {
        selectedDateTime = DateTime(
          selectedDateTime.year,
          selectedDateTime.month,
          selectedDateTime.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  Future<void> saveExpense() async {
    final amount = double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    await context.read<MainProvider>().addExpense(
      amount,
      selectedDateTime,
      selectedCategory,
      noteController.text,
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> updateExpense() async {
    final amount = double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    await context.read<MainProvider>().updateExpense(
      widget.expenseModel!.copyWith(
        amount: amount,
        timeStamp: selectedDateTime,
        category: selectedCategory,
        note: noteController.text,
      ),
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.expenseModel != null ? 'Update expense' : 'Add expense',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Amount'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Date'),
            subtitle: Text(
              MaterialLocalizations.of(context).formatMediumDate(selectedDateTime),
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: pickDate,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Time'),
            subtitle: Text(
              MaterialLocalizations.of(context).formatTimeOfDay(
                TimeOfDay.fromDateTime(selectedDateTime),
              ),
            ),
            trailing: const Icon(Icons.access_time),
            onTap: pickTime,
          ),
          DropdownButton<Category>(
            value: selectedCategory,
            isExpanded: true,
            items: Category.values.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (category) {
              if (category != null) {
                setState(() {
                  selectedCategory = category;
                });
              }
            },
          ),
          TextField(
            controller: noteController,
            decoration: const InputDecoration(labelText: 'Note'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (widget.expenseModel != null) {
              updateExpense();
            } else {
              saveExpense();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

//copywith
