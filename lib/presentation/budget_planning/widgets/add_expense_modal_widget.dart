import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddExpenseModalWidget extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final Function(Map<String, dynamic>) onAddExpense;

  const AddExpenseModalWidget({
    Key? key,
    required this.categories,
    required this.onAddExpense,
  }) : super(key: key);

  @override
  State<AddExpenseModalWidget> createState() => _AddExpenseModalWidgetState();
}

class _AddExpenseModalWidgetState extends State<AddExpenseModalWidget> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _merchantController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  Map<String, dynamic>? _selectedCategory;
  String _transactionType = 'expense';

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addExpense() {
    if (_amountController.text.isEmpty ||
        _merchantController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
        ),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
        ),
      );
      return;
    }

    final expense = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'amount': amount,
      'merchant': _merchantController.text.trim(),
      'category': _selectedCategory,
      'notes': _notesController.text.trim(),
      'date': DateTime.now().toIso8601String(),
      'type': _transactionType,
    };

    widget.onAddExpense(expense);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    Text(
                      'Add Transaction',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    TextButton(
                      onPressed: _addExpense,
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transaction Type Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _transactionType = 'expense'),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 3.h),
                              decoration: BoxDecoration(
                                color: _transactionType == 'expense'
                                    ? AppTheme.errorLight
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Expense',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: _transactionType == 'expense'
                                          ? Colors.white
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _transactionType = 'income'),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 3.h),
                              decoration: BoxDecoration(
                                color: _transactionType == 'income'
                                    ? AppTheme.successLight
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Income',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: _transactionType == 'income'
                                          ? Colors.white
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Amount Input
                  Text(
                    'Amount *',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 1.h),
                  TextFormField(
                    controller: _amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    decoration: InputDecoration(
                      hintText: '0.00',
                      prefixText: '\$ ',
                      prefixStyle:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 3.h),

                  // Merchant Input
                  Text(
                    'Merchant/Description *',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 1.h),
                  TextFormField(
                    controller: _merchantController,
                    decoration: const InputDecoration(
                      hintText: 'Enter merchant name or description',
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Category Selection
                  Text(
                    'Category *',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    height: 12.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.categories.length,
                      itemBuilder: (context, index) {
                        final category = widget.categories[index];
                        final isSelected =
                            _selectedCategory?['id'] == category['id'];

                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedCategory = category),
                          child: Container(
                            width: 20.w,
                            margin: EdgeInsets.only(right: 3.w),
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Color(category['color'] as int)
                                      .withValues(alpha: 0.2)
                                  : Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Color(category['color'] as int)
                                    : Theme.of(context)
                                        .colorScheme
                                        .outline
                                        .withValues(alpha: 0.3),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName: category['icon'] as String,
                                  color: Color(category['color'] as int),
                                  size: 6.w,
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  category['name'] as String,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Notes Input
                  Text(
                    'Notes (Optional)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 1.h),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Add any additional notes...',
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Add Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addExpense,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        backgroundColor: _transactionType == 'expense'
                            ? AppTheme.errorLight
                            : AppTheme.successLight,
                      ),
                      child: Text(
                        'Add ${_transactionType == 'expense' ? 'Expense' : 'Income'}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
