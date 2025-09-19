import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class GetExpensesByDateRange implements UseCase<List<Expense>, GetExpensesByDateRangeParams> {
  final ExpenseRepository repository;

  GetExpensesByDateRange(this.repository);

  @override
  Future<Either<Failure, List<Expense>>> call(GetExpensesByDateRangeParams params) async {
    return await repository.getExpensesByDateRange(params.startDate, params.endDate);
  }
}

class GetExpensesByDateRangeParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  const GetExpensesByDateRangeParams({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}