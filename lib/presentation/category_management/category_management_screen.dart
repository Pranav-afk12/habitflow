import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_category_modal_widget.dart';
import './widgets/category_list_widget.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({Key? key}) : super(key: key);

  @override
  State<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedType = 'habits';

  // Mock data for different category types
  Map<String, List<Map<String, dynamic>>> _categories = {
    'habits': [
      {
        'id': 1,
        'name': 'Health',
        'icon': 'favorite',
        'color': 0xFF4CAF50,
        'itemCount': 8,
        'isEditable': true,
      },
      {
        'id': 2,
        'name': 'Productivity',
        'icon': 'work',
        'color': 0xFF2196F3,
        'itemCount': 5,
        'isEditable': true,
      },
      {
        'id': 3,
        'name': 'Learning',
        'icon': 'school',
        'color': 0xFFFF9800,
        'itemCount': 3,
        'isEditable': true,
      },
      {
        'id': 4,
        'name': 'Personal',
        'icon': 'person',
        'color': 0xFF9C27B0,
        'itemCount': 4,
        'isEditable': true,
      },
    ],
    'budget': [
      {
        'id': 1,
        'name': 'Food & Dining',
        'icon': 'restaurant',
        'color': 0xFFE74C3C,
        'budget': 800.0,
        'spent': 650.0,
        'isEditable': true,
      },
      {
        'id': 2,
        'name': 'Transportation',
        'icon': 'directions_car',
        'color': 0xFF3498DB,
        'budget': 400.0,
        'spent': 320.0,
        'isEditable': true,
      },
      {
        'id': 3,
        'name': 'Entertainment',
        'icon': 'movie',
        'color': 0xFF9B59B6,
        'budget': 300.0,
        'spent': 180.0,
        'isEditable': true,
      },
      {
        'id': 4,
        'name': 'Shopping',
        'icon': 'shopping_bag',
        'color': 0xFFE67E22,
        'budget': 500.0,
        'spent': 420.0,
        'isEditable': true,
      },
    ],
    'exercises': [
      {
        'id': 1,
        'name': 'Strength',
        'icon': 'fitness_center',
        'color': 0xFFE74C3C,
        'itemCount': 15,
        'isEditable': true,
      },
      {
        'id': 2,
        'name': 'Cardio',
        'icon': 'directions_run',
        'color': 0xFF3498DB,
        'itemCount': 12,
        'isEditable': true,
      },
      {
        'id': 3,
        'name': 'Flexibility',
        'icon': 'self_improvement',
        'color': 0xFF9B59B6,
        'itemCount': 8,
        'isEditable': true,
      },
      {
        'id': 4,
        'name': 'Sports',
        'icon': 'sports_basketball',
        'color': 0xFFE67E22,
        'itemCount': 6,
        'isEditable': true,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        switch (_tabController.index) {
          case 0:
            _selectedType = 'habits';
            break;
          case 1:
            _selectedType = 'budget';
            break;
          case 2:
            _selectedType = 'exercises';
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addCategory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddCategoryModalWidget(
        categoryType: _selectedType,
        onAddCategory: _onAddCategory,
      ),
    );
  }

  void _onAddCategory(Map<String, dynamic> category) {
    setState(() {
      final newId = (_categories[_selectedType]?.length ?? 0) + 1;
      category['id'] = newId;
      category['isEditable'] = true;
      _categories[_selectedType]?.add(category);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${category['name']} added successfully'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _editCategory(Map<String, dynamic> category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddCategoryModalWidget(
        categoryType: _selectedType,
        category: category,
        onAddCategory: (updatedCategory) {
          setState(() {
            final index = _categories[_selectedType]?.indexWhere(
                  (cat) => cat['id'] == category['id'],
                ) ??
                -1;
            if (index != -1) {
              _categories[_selectedType]![index] = {
                ...category,
                ...updatedCategory,
              };
            }
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${updatedCategory['name']} updated successfully'),
              backgroundColor: AppTheme.lightTheme.primaryColor,
            ),
          );
        },
      ),
    );
  }

  void _deleteCategory(Map<String, dynamic> category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Category'),
        content: Text(
          'Are you sure you want to delete "${category['name']}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _categories[_selectedType]?.removeWhere(
                  (cat) => cat['id'] == category['id'],
                );
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${category['name']} deleted successfully'),
                  backgroundColor: AppTheme.errorLight,
                ),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppTheme.errorLight),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Manage Categories'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color:
                Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'track_changes',
                        color: _tabController.index == 0
                            ? AppTheme.lightTheme.primaryColor
                            : Theme.of(context).textTheme.bodySmall?.color,
                        size: 18,
                      ),
                      SizedBox(width: 1.w),
                      Text('Habits'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'account_balance_wallet',
                        color: _tabController.index == 1
                            ? AppTheme.lightTheme.primaryColor
                            : Theme.of(context).textTheme.bodySmall?.color,
                        size: 18,
                      ),
                      SizedBox(width: 1.w),
                      Text('Budget'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'fitness_center',
                        color: _tabController.index == 2
                            ? AppTheme.lightTheme.primaryColor
                            : Theme.of(context).textTheme.bodySmall?.color,
                        size: 18,
                      ),
                      SizedBox(width: 1.w),
                      Text('Exercises'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                CategoryListWidget(
                  categories: _categories['habits'] ?? [],
                  categoryType: 'habits',
                  onEdit: _editCategory,
                  onDelete: _deleteCategory,
                ),
                CategoryListWidget(
                  categories: _categories['budget'] ?? [],
                  categoryType: 'budget',
                  onEdit: _editCategory,
                  onDelete: _deleteCategory,
                ),
                CategoryListWidget(
                  categories: _categories['exercises'] ?? [],
                  categoryType: 'exercises',
                  onEdit: _editCategory,
                  onDelete: _deleteCategory,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCategory,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
        label: Text(
          'Add Category',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
