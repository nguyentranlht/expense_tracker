import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/delete_expense.dart';
import '../../domain/usecases/get_all_expenses.dart';
import '../../domain/usecases/get_expenses_by_date_range.dart';
import '../../domain/usecases/update_expense.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final GetAllExpenses getAllExpenses;
  final AddExpense addExpense;
  final UpdateExpense updateExpense;
  final DeleteExpense deleteExpense;
  final GetExpensesByDateRange getExpensesByDateRange;

  ExpenseBloc({
    required this.getAllExpenses,
    required this.addExpense,
    required this.updateExpense,
    required this.deleteExpense,
    required this.getExpensesByDateRange,
  }) : super(ExpenseInitial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<AddExpenseEvent>(_onAddExpense);
    on<UpdateExpenseEvent>(_onUpdateExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
    on<LoadExpensesByDateRange>(_onLoadExpensesByDateRange);
  }

  Future<void> _onLoadExpenses(LoadExpenses event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    
    final result = await getAllExpenses(const NoParams());
    
    result.fold(
      (failure) => emit(ExpenseError(failure.toString())),
      (expenses) => emit(ExpenseLoaded(expenses)),
    );
  }

  Future<void> _onAddExpense(AddExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    
    final result = await addExpense(AddExpenseParams(expense: event.expense));
    
    result.fold(
      (failure) => emit(ExpenseError(failure.toString())),
      (id) {
        emit(const ExpenseOperationSuccess('Expense added successfully!'));
        add(LoadExpenses()); // Reload expenses
      },
    );
  }

  Future<void> _onUpdateExpense(UpdateExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    
    final result = await updateExpense(UpdateExpenseParams(expense: event.expense));
    
    result.fold(
      (failure) => emit(ExpenseError(failure.toString())),
      (_) {
        emit(const ExpenseOperationSuccess('Expense updated successfully!'));
        add(LoadExpenses()); // Reload expenses
      },
    );
  }

  Future<void> _onDeleteExpense(DeleteExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    
    final result = await deleteExpense(DeleteExpenseParams(id: event.id));
    
    result.fold(
      (failure) => emit(ExpenseError(failure.toString())),
      (_) {
        emit(const ExpenseOperationSuccess('Expense deleted successfully!'));
        add(LoadExpenses()); // Reload expenses
      },
    );
  }

  Future<void> _onLoadExpensesByDateRange(LoadExpensesByDateRange event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    
    final result = await getExpensesByDateRange(
      GetExpensesByDateRangeParams(
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );
    
    result.fold(
      (failure) => emit(ExpenseError(failure.toString())),
      (expenses) => emit(ExpenseLoaded(expenses)),
    );
  }
}