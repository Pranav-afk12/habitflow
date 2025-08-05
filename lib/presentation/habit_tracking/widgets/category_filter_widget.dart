import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryFilterWidget extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  const CategoryFilterWidget({
    Key? key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      'All',
      'Health',
      'Productivity',
      'Learning',
      'Personal'
    ];

    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: categories.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          final categoryColor = _getCategoryColor(category);

          return GestureDetector(
            onTap: () => onCategoryChanged(category),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? categoryColor
                    : categoryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? categoryColor
                      : categoryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: _getCategoryIcon(category),
                    color: isSelected ? Colors.white : categoryColor,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    category,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: isSelected ? Colors.white : categoryColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'all':
        return AppTheme.lightTheme.primaryColor;
      case 'health':
        return AppTheme.successLight;
      case 'productivity':
        return AppTheme.lightTheme.primaryColor;
      case 'learning':
        return AppTheme.accentLight;
      case 'personal':
        return AppTheme.warningLight;
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'all':
        return 'apps';
      case 'health':
        return 'favorite';
      case 'productivity':
        return 'work';
      case 'learning':
        return 'school';
      case 'personal':
        return 'person';
      default:
        return 'star';
    }
  }
}
