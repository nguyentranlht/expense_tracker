import 'package:get_it/get_it.dart';
import 'features/expense_tracking/data/datasources/database_helper.dart';
import 'features/expense_tracking/data/datasources/expense_local_data_source.dart';
import 'features/expense_tracking/data/repositories/expense_repository_impl.dart';
import 'features/expense_tracking/domain/repositories/expense_repository.dart';
import 'features/expense_tracking/domain/usecases/add_expense.dart';
import 'features/expense_tracking/domain/usecases/delete_expense.dart';
import 'features/expense_tracking/domain/usecases/get_all_expenses.dart';
import 'features/expense_tracking/domain/usecases/get_expenses_by_date_range.dart';
import 'features/expense_tracking/domain/usecases/update_expense.dart';
import 'features/expense_tracking/presentation/bloc/expense_bloc.dart';

final sl = GetIt.instance; // Service Locator

Future<void> init() async {
  // Features - Expense Tracking

  // Bloc
  sl.registerLazySingleton(
    () => ExpenseBloc(
      getAllExpenses: sl(),
      addExpense: sl(),
      updateExpense: sl(),
      deleteExpense: sl(),
      getExpensesByDateRange: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllExpenses(sl()));
  sl.registerLazySingleton(() => AddExpense(sl()));
  sl.registerLazySingleton(() => UpdateExpense(sl()));
  sl.registerLazySingleton(() => DeleteExpense(sl()));
  sl.registerLazySingleton(() => GetExpensesByDateRange(sl()));

  // Repository
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSourceImpl(
      databaseHelper: sl(),
    ),
  );

  // Core
  sl.registerLazySingleton(() => DatabaseHelper.instance);
}