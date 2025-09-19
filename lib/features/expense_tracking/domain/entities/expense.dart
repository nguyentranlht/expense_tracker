import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final int? id;
  final String title;
  final String description;
  final double amount;
  final String category;
  final DateTime date;
  final DateTime createdAt;

  const Expense({
    this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    required this.createdAt,
  });

  Expense copyWith({
    int? id,
    String? title,
    String? description,
    double? amount,
    String? category,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    amount,
    category,
    date,
    createdAt,
  ];
}