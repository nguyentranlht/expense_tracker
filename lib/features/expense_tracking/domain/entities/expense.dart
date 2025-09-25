import 'package:equatable/equatable.dart';

enum TransactionType { income, expense }

class Expense extends Equatable {
  final int? id;
  final String title;
  final String description;
  final double amount;
  final String category;
  final TransactionType type;
  final DateTime date;
  final DateTime createdAt;

  const Expense({
    this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.category,
    this.type = TransactionType.expense, // Default to expense for backward compatibility
    required this.date,
    required this.createdAt,
  });

  // Convenience constructors
  const Expense.expense({
    int? id,
    required String title,
    required String description,
    required double amount,
    required String category,
    required DateTime date,
    required DateTime createdAt,
  }) : this(
          id: id,
          title: title,
          description: description,
          amount: amount,
          category: category,
          type: TransactionType.expense,
          date: date,
          createdAt: createdAt,
        );

  const Expense.income({
    int? id,
    required String title,
    required String description,
    required double amount,
    required String category,
    required DateTime date,
    required DateTime createdAt,
  }) : this(
          id: id,
          title: title,
          description: description,
          amount: amount,
          category: category,
          type: TransactionType.income,
          date: date,
          createdAt: createdAt,
        );

  Expense copyWith({
    int? id,
    String? title,
    String? description,
    double? amount,
    String? category,
    TransactionType? type,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return Expense(
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

  // Helper getters
  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;
  String get typeString => type == TransactionType.income ? 'income' : 'expense';
  String get typeDisplayName => type == TransactionType.income ? 'Thu nhập' : 'Chi tiêu';

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    amount,
    category,
    type,
    date,
    createdAt,
  ];
}