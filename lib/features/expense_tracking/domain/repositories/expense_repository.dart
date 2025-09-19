import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, List<Expense>>> getAllExpenses();
  Future<Either<Failure, Expense>> getExpenseById(int id);
  Future<Either<Failure, List<Expense>>> getExpensesByCategory(String category);
  Future<Either<Failure, List<Expense>>> getExpensesByDateRange(
    DateTime startDate, 
    DateTime endDate
  );
  Future<Either<Failure, int>> addExpense(Expense expense);
  Future<Either<Failure, void>> updateExpense(Expense expense);
  Future<Either<Failure, void>> deleteExpense(int id);
  Future<Either<Failure, double>> getTotalExpensesByCategory(String category);
  Future<Either<Failure, double>> getTotalExpensesByDateRange(
    DateTime startDate, 
    DateTime endDate
  );
}