import 'package:expanse_tracker/core/providers/main_provider.dart';
import 'package:expanse_tracker/core/widgets/expense_tile.dart';
import 'package:expanse_tracker/core/widgets/add_expense_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MainProvider>().loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MainProvider>(
        builder: (context, mainProvider, child) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total Expenses: ${mainProvider.totalExpenses()}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: mainProvider.expenses.length,
                itemBuilder: (context, index) =>
                    ExpenseTile(expense: mainProvider.expenses[index]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddExpenseDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
