import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_expense_modal_widget.dart';
import './widgets/budget_header_widget.dart';
import './widgets/category_card_widget.dart';
import './widgets/transaction_item_widget.dart';

class BudgetPlanning extends StatefulWidget {
  const BudgetPlanning({Key? key}) : super(key: key);

  @override
  State<BudgetPlanning> createState() => _BudgetPlanningState();
}

class _BudgetPlanningState extends State<BudgetPlanning>
    with TickerProviderStateMixin {
  DateTime _currentMonth = DateTime.now();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isRefreshing = false;
  late TabController _tabController;

  // Mock data for categories
  final List<Map<String, dynamic>> _categories = [
    {
      'id': 1,
      'name': 'Food & Dining',
      'icon': 'restaurant',
      'color': 0xFFE74C3C,
      'budget': 800.0,
      'spent': 650.0,
    },
    {
      'id': 2,
      'name': 'Transportation',
      'icon': 'directions_car',
      'color': 0xFF3498DB,
      'budget': 400.0,
      'spent': 320.0,
    },
    {
      'id': 3,
      'name': 'Entertainment',
      'icon': 'movie',
      'color': 0xFF9B59B6,
      'budget': 300.0,
      'spent': 180.0,
    },
    {
      'id': 4,
      'name': 'Shopping',
      'icon': 'shopping_bag',
      'color': 0xFFE67E22,
      'budget': 500.0,
      'spent': 420.0,
    },
    {
      'id': 5,
      'name': 'Health',
      'icon': 'local_hospital',
      'color': 0xFF27AE60,
      'budget': 200.0,
      'spent': 85.0,
    },
    {
      'id': 6,
      'name': 'Utilities',
      'icon': 'flash_on',
      'color': 0xFFF39C12,
      'budget': 350.0,
      'spent': 340.0,
    },
  ];

  // Mock data for transactions
  List<Map<String, dynamic>> _transactions = [
    {
      'id': 1,
      'amount': 45.50,
      'merchant': 'Starbucks Coffee',
      'category': {
        'id': 1,
        'name': 'Food & Dining',
        'icon': 'restaurant',
        'color': 0xFFE74C3C,
      },
      'notes': 'Morning coffee and pastry',
      'date': '2025-08-05T08:15:00.000Z',
      'type': 'expense',
    },
    {
      'id': 2,
      'amount': 85.20,
      'merchant': 'Shell Gas Station',
      'category': {
        'id': 2,
        'name': 'Transportation',
        'icon': 'directions_car',
        'color': 0xFF3498DB,
      },
      'notes': 'Weekly gas fill-up',
      'date': '2025-08-04T18:30:00.000Z',
      'type': 'expense',
    },
    {
      'id': 3,
      'amount': 25.99,
      'merchant': 'Netflix Subscription',
      'category': {
        'id': 3,
        'name': 'Entertainment',
        'icon': 'movie',
        'color': 0xFF9B59B6,
      },
      'notes': 'Monthly streaming service',
      'date': '2025-08-04T12:00:00.000Z',
      'type': 'expense',
    },
    {
      'id': 4,
      'amount': 120.00,
      'merchant': 'Target Store',
      'category': {
        'id': 4,
        'name': 'Shopping',
        'icon': 'shopping_bag',
        'color': 0xFFE67E22,
      },
      'notes': 'Household essentials and groceries',
      'date': '2025-08-03T16:45:00.000Z',
      'type': 'expense',
    },
    {
      'id': 5,
      'amount': 2500.00,
      'merchant': 'Salary Deposit',
      'category': {
        'id': 7,
        'name': 'Income',
        'icon': 'account_balance_wallet',
        'color': 0xFF27AE60,
      },
      'notes': 'Monthly salary',
      'date': '2025-08-01T09:00:00.000Z',
      'type': 'income',
    },
    {
      'id': 6,
      'amount': 65.75,
      'merchant': 'CVS Pharmacy',
      'category': {
        'id': 5,
        'name': 'Health',
        'icon': 'local_hospital',
        'color': 0xFF27AE60,
      },
      'notes': 'Prescription medication',
      'date': '2025-08-02T14:20:00.000Z',
      'type': 'expense',
    },
    {
      'id': 7,
      'amount': 180.50,
      'merchant': 'Electric Company',
      'category': {
        'id': 6,
        'name': 'Utilities',
        'icon': 'flash_on',
        'color': 0xFFF39C12,
      },
      'notes': 'Monthly electricity bill',
      'date': '2025-08-01T10:30:00.000Z',
      'type': 'expense',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  double get _totalBudget {
    return (_categories as List).fold(
        0.0, (sum, category) => sum + (category['budget'] as num).toDouble());
  }

  double get _totalSpent {
    return (_transactions as List)
        .where((transaction) => (transaction['type'] as String) == 'expense')
        .fold(
            0.0,
            (sum, transaction) =>
                sum + (transaction['amount'] as num).toDouble());
  }

  List<Map<String, dynamic>> get _filteredTransactions {
    if (_searchQuery.isEmpty) return _transactions;

    return _transactions
        .where((transaction) {
          final merchant = (transaction['merchant'] as String).toLowerCase();
          final category =
              (transaction['category'] as Map<String, dynamic>?)?['name']
                      ?.toString()
                      .toLowerCase() ??
                  '';
          final query = _searchQuery.toLowerCase();

          return merchant.contains(query) || category.contains(query);
        })
        .toList()
        .cast<Map<String, dynamic>>();
  }

  void _navigateToPreviousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _navigateToNextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  void _openSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
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
                  Text(
                    'Budget Settings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    ListTile(
                      leading: CustomIconWidget(
                        iconName: 'category',
                        color: Theme.of(context).colorScheme.primary,
                        size: 6.w,
                      ),
                      title: const Text('Manage Categories'),
                      subtitle:
                          const Text('Add, edit, or remove budget categories'),
                      trailing: CustomIconWidget(
                        iconName: 'chevron_right',
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/category-management');
                      },
                    ),
                    ListTile(
                      leading: CustomIconWidget(
                        iconName: 'currency_exchange',
                        color: Theme.of(context).colorScheme.primary,
                        size: 6.w,
                      ),
                      title: const Text('Currency Settings'),
                      subtitle:
                          const Text('Change currency and display format'),
                      trailing: CustomIconWidget(
                        iconName: 'chevron_right',
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/currency-settings');
                      },
                    ),
                    ListTile(
                      leading: CustomIconWidget(
                        iconName: 'account_balance_wallet',
                        color: Theme.of(context).colorScheme.primary,
                        size: 6.w,
                      ),
                      title: const Text('Set Monthly Budget'),
                      subtitle:
                          const Text('Adjust your overall monthly budget'),
                      trailing: CustomIconWidget(
                        iconName: 'chevron_right',
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Budget setup coming soon!')),
                        );
                      },
                    ),
                    ListTile(
                      leading: CustomIconWidget(
                        iconName: 'notifications',
                        color: Theme.of(context).colorScheme.primary,
                        size: 6.w,
                      ),
                      title: const Text('Budget Alerts'),
                      subtitle:
                          const Text('Configure spending limit notifications'),
                      trailing: CustomIconWidget(
                        iconName: 'chevron_right',
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Alert settings coming soon!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCategoryDetails(Map<String, dynamic> category) {
    final categoryTransactions = (_transactions as List)
        .where((transaction) =>
            (transaction['category'] as Map<String, dynamic>?)?['id'] ==
            category['id'])
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(category['name'] as String),
            backgroundColor:
                Color(category['color'] as int).withValues(alpha: 0.1),
          ),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                color: Color(category['color'] as int).withValues(alpha: 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Budget',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '\$${(category['budget'] as num).toStringAsFixed(0)}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Spent',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '\$${(category['spent'] as num).toStringAsFixed(0)}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.errorLight,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: categoryTransactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'receipt_long',
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              size: 15.w,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'No transactions yet',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: categoryTransactions.length,
                        itemBuilder: (context, index) {
                          return TransactionItemWidget(
                            transaction: categoryTransactions[index],
                            onEdit: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Edit transaction coming soon!')),
                              );
                            },
                            onDelete: () {
                              setState(() {
                                _transactions.removeWhere((t) =>
                                    t['id'] ==
                                    categoryTransactions[index]['id']);
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addExpense(Map<String, dynamic> expense) {
    setState(() {
      _transactions.insert(0, expense);

      // Update category spent amount if it's an expense
      if (expense['type'] == 'expense' && expense['category'] != null) {
        final categoryId = (expense['category'] as Map<String, dynamic>)['id'];
        final categoryIndex =
            _categories.indexWhere((cat) => cat['id'] == categoryId);
        if (categoryIndex != -1) {
          _categories[categoryIndex]['spent'] =
              (_categories[categoryIndex]['spent'] as num).toDouble() +
                  (expense['amount'] as num).toDouble();
        }
      }
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Budget data refreshed!')),
    );
  }

  void _showAddExpenseModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddExpenseModalWidget(
        categories: _categories,
        onAddExpense: _addExpense,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            BudgetHeaderWidget(
              currentMonth: _currentMonth,
              totalBudget: _totalBudget,
              totalSpent: _totalSpent,
              onPreviousMonth: _navigateToPreviousMonth,
              onNextMonth: _navigateToNextMonth,
              onSettings: _openSettings,
            ),

            // Search Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: TextFormField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search transactions...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                          child: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'clear',
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              size: 5.w,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ),

            // Tab Bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Categories'),
                  Tab(text: 'Transactions'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Overview Tab
                  SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Categories Overview',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 2.h),
                        SizedBox(
                          height: 25.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _categories.length,
                            itemBuilder: (context, index) {
                              return CategoryCardWidget(
                                category: _categories[index],
                                onTap: () =>
                                    _openCategoryDetails(_categories[index]),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          'Recent Transactions',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 1.h),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filteredTransactions.take(5).length,
                          itemBuilder: (context, index) {
                            return TransactionItemWidget(
                              transaction: _filteredTransactions[index],
                              onEdit: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Edit transaction coming soon!')),
                                );
                              },
                              onDelete: () {
                                setState(() {
                                  _transactions.removeWhere((t) =>
                                      t['id'] ==
                                      _filteredTransactions[index]['id']);
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Categories Tab
                  GridView.builder(
                    padding: EdgeInsets.all(4.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 3.w,
                      mainAxisSpacing: 2.h,
                    ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      return CategoryCardWidget(
                        category: _categories[index],
                        onTap: () => _openCategoryDetails(_categories[index]),
                      );
                    },
                  ),

                  // Transactions Tab
                  _filteredTransactions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'receipt_long',
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                size: 15.w,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                _searchQuery.isNotEmpty
                                    ? 'No transactions found'
                                    : 'No transactions yet',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                              if (_searchQuery.isNotEmpty) ...[
                                SizedBox(height: 1.h),
                                Text(
                                  'Try adjusting your search terms',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredTransactions.length,
                          itemBuilder: (context, index) {
                            return TransactionItemWidget(
                              transaction: _filteredTransactions[index],
                              onEdit: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Edit transaction coming soon!')),
                                );
                              },
                              onDelete: () {
                                setState(() {
                                  _transactions.removeWhere((t) =>
                                      t['id'] ==
                                      _filteredTransactions[index]['id']);
                                });
                              },
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddExpenseModal,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 6.w,
        ),
        label: Text(
          'Add Transaction',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
