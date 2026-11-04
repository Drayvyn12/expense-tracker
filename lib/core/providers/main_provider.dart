import 'package:expanse_tracker/core/data/models/expense_model.dart';
import 'package:expanse_tracker/core/data/repositories/expense_repo.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

class MainProvider extends ChangeNotifier {
  List<ExpenseModel> expenses = [];

  Future<void> addExpense(
    double amount,
    DateTime timeStamp,
    Category category,
    String note,
  ) async {
    expenses.add(
      ExpenseModel(
        amount: amount,
        timeStamp: timeStamp,
        category: category,
        note: note,
      ),
    );

    notifyListeners();
    await ExpenseRepo.saveExpenses(expenses);
  }

  double totalExpenses() {
    return expenses.fold(0, (sum, e) => sum + e.amount);
  }

  void loadExpenses() async {
    expenses = await ExpenseRepo.getExpenses();
    notifyListeners();
  }

  void deleteExpense(String id) {
    expenses.removeWhere((e) => e.id == id);
    notifyListeners();
    ExpenseRepo.saveExpenses(expenses);
  }

  Future<void> updateExpense(ExpenseModel updatedExpenseModel) async {
    expenses[expenses.indexWhere((e) => e.id == updatedExpenseModel.id)] =
        updatedExpenseModel;
    notifyListeners();
    ExpenseRepo.saveExpenses(expenses);
  }
}
