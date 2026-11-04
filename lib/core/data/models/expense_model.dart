import 'package:uuid/uuid.dart';

enum Category { food, travel, others }

class ExpenseModel {
  static const _uuid = Uuid();

  String id;
  double amount;
  DateTime timeStamp;
  Category category;
  String note;

  ExpenseModel({
    String? id,
    required this.amount,
    required this.timeStamp,
    required this.category,
    required this.note,
  }) : id = id ?? _uuid.v4();

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      timeStamp: DateTime.parse(json['timeStamp'] as String),
      category: Category.values.byName(json['category'] as String),
      note: json['note'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'timeStamp': timeStamp.toIso8601String(),
      'category': category.name,
      'note': note,
    };
  }

  ExpenseModel copyWith({
    String? id,
    double? amount,
    DateTime? timeStamp,
    Category? category,
    String? note,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      timeStamp: timeStamp ?? this.timeStamp,
      category: category ?? this.category,
      note: note ?? this.note,
    );
  }
}
