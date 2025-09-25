import 'package:intl/intl.dart';
import '../../domain/entities/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    super.id,
    required super.title,
    required super.description,
    required super.amount,
    required super.category,
    super.type = TransactionType.expense,
    required super.date,
    required super.createdAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      type: json['type'] != null 
          ? (json['type'] == 'income' ? TransactionType.income : TransactionType.expense)
          : TransactionType.expense, // Default for backward compatibility
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'category': category,
      'type': typeString,
      'date': dateFormatter.format(date),
      'created_at': dateFormatter.format(createdAt),
    };
  }

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      title: expense.title,
      description: expense.description,
      amount: expense.amount,
      category: expense.category,
      type: expense.type,
      date: expense.date,
      createdAt: expense.createdAt,
    );
  }

  @override
  ExpenseModel copyWith({
    int? id,
    String? title,
    String? description,
    double? amount,
    String? category,
    TransactionType? type,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      type: type ?? this.type,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}