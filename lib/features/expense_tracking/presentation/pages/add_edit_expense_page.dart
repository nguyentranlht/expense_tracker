import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/constants.dart';
import '../../domain/entities/expense.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';

class AddEditExpensePage extends StatefulWidget {
  final Expense? expense;

  const AddEditExpensePage({super.key, this.expense});

  @override
  State<AddEditExpensePage> createState() => _AddEditExpensePageState();
}

class _AddEditExpensePageState extends State<AddEditExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  String _selectedCategory = Constants.defaultCategories.first['name'];
  DateTime _selectedDate = DateTime.now();
  TransactionType _selectedType = TransactionType.expense;

  bool get isEditing => widget.expense != null;
  
  List<Map<String, dynamic>> get _currentCategories {
    return _selectedType == TransactionType.income 
        ? Constants.defaultIncomeCategories 
        : Constants.defaultCategories;
  }

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _titleController.text = widget.expense!.title;
      _descriptionController.text = widget.expense!.description;
      _amountController.text = widget.expense!.amount.toString();
      _selectedCategory = widget.expense!.category;
      _selectedDate = widget.expense!.date;
      _selectedType = widget.expense!.type;
    }
    // Set default category for current type
    _selectedCategory = _currentCategories.first['name'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseBloc, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pop();
        } else if (state is ExpenseError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing 
              ? 'Sửa ${_selectedType == TransactionType.income ? "Thu nhập" : "Chi tiêu"}' 
              : 'Thêm ${_selectedType == TransactionType.income ? "Thu nhập" : "Chi tiêu"}'),
          backgroundColor: _selectedType == TransactionType.income 
              ? Colors.green 
              : Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Transaction type toggle
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedType = TransactionType.expense;
                                          _selectedCategory = Constants.defaultCategories.first['name'];
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        decoration: BoxDecoration(
                                          color: _selectedType == TransactionType.expense
                                              ? Theme.of(context).primaryColor
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Chi tiêu',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: _selectedType == TransactionType.expense
                                                ? Colors.white
                                                : Colors.grey[600],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedType = TransactionType.income;
                                          _selectedCategory = Constants.defaultIncomeCategories.first['name'];
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        decoration: BoxDecoration(
                                          color: _selectedType == TransactionType.income
                                              ? Colors.green
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Thu nhập',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: _selectedType == TransactionType.income
                                                ? Colors.white
                                                : Colors.grey[600],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Title field
                            TextFormField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                labelText: 'Tiêu đề *',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.title),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập tiêu đề';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Amount field
                            TextFormField(
                              controller: _amountController,
                              decoration: const InputDecoration(
                                labelText: 'Số tiền *',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.attach_money),
                                suffixText: 'VNĐ',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập số tiền';
                                }
                                final amount = double.tryParse(value);
                                if (amount == null || amount <= 0) {
                                  return 'Số tiền phải lớn hơn 0';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Description field
                            TextFormField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                labelText: 'Mô tả',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.description),
                              ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),

                            // Category dropdown
                            DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              decoration: InputDecoration(
                                labelText: _selectedType == TransactionType.income 
                                    ? 'Nguồn thu nhập *' 
                                    : 'Danh mục *',
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.category),
                              ),
                              items: _currentCategories.map((category) {
                                return DropdownMenuItem<String>(
                                  value: category['name'] as String,
                                  child: Text(category['name'] as String),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 16),

                            // Date picker
                            InkWell(
                              onTap: _selectDate,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Ngày chi tiêu *',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.calendar_today),
                                ),
                                child: Text(
                                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Save button
                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: const EdgeInsets.only(top: 16),
                      child: ElevatedButton(
                        onPressed: state is ExpenseLoading ? null : _saveExpense,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedType == TransactionType.income 
                              ? Colors.green 
                              : Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: state is ExpenseLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                isEditing 
                                    ? 'Cập nhật' 
                                    : (_selectedType == TransactionType.income ? 'Thêm thu nhập' : 'Thêm chi tiêu'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final expense = Expense(
        id: isEditing ? widget.expense!.id : null,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        type: _selectedType,
        date: _selectedDate,
        createdAt: isEditing ? widget.expense!.createdAt : DateTime.now(),
      );

      if (isEditing) {
        context.read<ExpenseBloc>().add(UpdateExpenseEvent(expense));
      } else {
        context.read<ExpenseBloc>().add(AddExpenseEvent(expense));
      }
    }
  }
}
