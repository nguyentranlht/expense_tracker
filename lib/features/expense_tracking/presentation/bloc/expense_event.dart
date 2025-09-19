import 'package:equatable/equatable.dart';
import '../../domain/entities/expense.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object> get props => [];
}

class LoadExpenses extends ExpenseEvent {}

class AddExpenseEvent extends ExpenseEvent {
  final Expense expense;

  const AddExpenseEvent(this.expense);

  @override
  List<Object> get props => [expense];
}

class UpdateExpenseEvent extends ExpenseEvent {
  final Expense expense;

  const UpdateExpenseEvent(this.expense);

  @override
  List<Object> get props => [expense];
}

class DeleteExpenseEvent extends ExpenseEvent {
  final int id;

  const DeleteExpenseEvent(this.id);

  @override
  List<Object> get props => [id];
}

class LoadExpensesByDateRange extends ExpenseEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LoadExpensesByDateRange(this.startDate, this.endDate);

  @override
  List<Object> get props => [startDate, endDate];
}