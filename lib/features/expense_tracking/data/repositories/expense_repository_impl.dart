import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_data_source.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;

  ExpenseRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Expense>>> getAllExpenses() async {
    try {
      final expenseModels = await localDataSource.getAllExpenses();
      return Right(expenseModels);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Expense>> getExpenseById(int id) async {
    try {
      final expenseModel = await localDataSource.getExpenseById(id);
      return Right(expenseModel);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpensesByCategory(String category) async {
    try {
      final expenseModels = await localDataSource.getExpensesByCategory(category);
      return Right(expenseModels);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpensesByDateRange(
    DateTime startDate, 
    DateTime endDate
  ) async {
    try {
      final expenseModels = await localDataSource.getExpensesByDateRange(startDate, endDate);
      return Right(expenseModels);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> addExpense(Expense expense) async {
    try {
      final expenseModel = ExpenseModel.fromEntity(expense);
      final id = await localDataSource.insertExpense(expenseModel);
      return Right(id);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateExpense(Expense expense) async {
    try {
      final expenseModel = ExpenseModel.fromEntity(expense);
      await localDataSource.updateExpense(expenseModel);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(int id) async {
    try {
      await localDataSource.deleteExpense(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalExpensesByCategory(String category) async {
    try {
      final total = await localDataSource.getTotalExpensesByCategory(category);
      return Right(total);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalExpensesByDateRange(
    DateTime startDate, 
    DateTime endDate
  ) async {
    try {
      final total = await localDataSource.getTotalExpensesByDateRange(startDate, endDate);
      return Right(total);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}