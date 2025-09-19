import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class GetAllExpenses implements UseCase<List<Expense>, NoParams> {
  final ExpenseRepository repository;

  GetAllExpenses(this.repository);

  @override
  Future<Either<Failure, List<Expense>>> call(NoParams params) async {
    return await repository.getAllExpenses();
  }
}