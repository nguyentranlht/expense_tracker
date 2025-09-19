import '../../../../core/constants/constants.dart';
import '../models/expense_model.dart';
import 'database_helper.dart';

abstract class ExpenseLocalDataSource {
  Future<List<ExpenseModel>> getAllExpenses();
  Future<ExpenseModel> getExpenseById(int id);
  Future<List<ExpenseModel>> getExpensesByCategory(String category);
  Future<List<ExpenseModel>> getExpensesByDateRange(DateTime startDate, DateTime endDate);
  Future<int> insertExpense(ExpenseModel expense);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(int id);
  Future<double> getTotalExpensesByCategory(String category);
  Future<double> getTotalExpensesByDateRange(DateTime startDate, DateTime endDate);
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final DatabaseHelper databaseHelper;

  ExpenseLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<ExpenseModel>> getAllExpenses() async {
    final db = await databaseHelper.database;
    final result = await db.query(
      Constants.expenseTable,
      orderBy: 'date DESC',
    );
    
    return result.map((json) => ExpenseModel.fromJson(json)).toList();
  }

  @override
  Future<ExpenseModel> getExpenseById(int id) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      Constants.expenseTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return ExpenseModel.fromJson(result.first);
    } else {
      throw Exception('Expense not found');
    }
  }

  @override
  Future<List<ExpenseModel>> getExpensesByCategory(String category) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      Constants.expenseTable,
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'date DESC',
    );
    
    return result.map((json) => ExpenseModel.fromJson(json)).toList();
  }

  @override
  Future<List<ExpenseModel>> getExpensesByDateRange(DateTime startDate, DateTime endDate) async {
    final db = await databaseHelper.database;
    final startDateStr = startDate.toIso8601String().split('T')[0];
    final endDateStr = endDate.toIso8601String().split('T')[0];
    
    final result = await db.query(
      Constants.expenseTable,
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDateStr, endDateStr],
      orderBy: 'date DESC',
    );
    
    return result.map((json) => ExpenseModel.fromJson(json)).toList();
  }

  @override
  Future<int> insertExpense(ExpenseModel expense) async {
    final db = await databaseHelper.database;
    final json = expense.toJson();
    json.remove('id'); // Remove id for auto increment
    
    return await db.insert(Constants.expenseTable, json);
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    final db = await databaseHelper.database;
    await db.update(
      Constants.expenseTable,
      expense.toJson(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  @override
  Future<void> deleteExpense(int id) async {
    final db = await databaseHelper.database;
    await db.delete(
      Constants.expenseTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<double> getTotalExpensesByCategory(String category) async {
    final db = await databaseHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM ${Constants.expenseTable} WHERE category = ?',
      [category],
    );
    
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  @override
  Future<double> getTotalExpensesByDateRange(DateTime startDate, DateTime endDate) async {
    final db = await databaseHelper.database;
    final startDateStr = startDate.toIso8601String().split('T')[0];
    final endDateStr = endDate.toIso8601String().split('T')[0];
    
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM ${Constants.expenseTable} WHERE date BETWEEN ? AND ?',
      [startDateStr, endDateStr],
    );
    
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }
}