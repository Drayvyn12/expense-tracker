import 'dart:convert';

import '../../services/shared_preferences/shared_preferences_services.dart';
import '../models/expense_model.dart';

class ExpenseRepo {
  static Future<List<ExpenseModel>> getExpenses() async {
    SharedPreferencesService sharedPreferencesService =
        await SharedPreferencesService.getInstance();
    final List<String> expensesStrings =
        sharedPreferencesService.getStringList('expenses') ?? [];
    List<ExpenseModel> expenses = expensesStrings.map((expense) {
      return ExpenseModel.fromJson(jsonDecode(expense));
    }).toList();

    return expenses;
  }

  static Future<void> saveExpenses(List<ExpenseModel> expenses) async {
    SharedPreferencesService sharedPreferencesService =
        await SharedPreferencesService.getInstance();
    final List<String> expensesStrings = expenses.map((expense) {
      return jsonEncode(expense.toJson());
    }).toList();
    await sharedPreferencesService.setStringList('expenses', expensesStrings);
  }
}
