import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final String categoryType;
  final Function(Map<String, dynamic>) onEdit;
  final Function(Map<String, dynamic>) onDelete;

  const CategoryListWidget({
    Key? key,
    required this.categories,
    required this.categoryType,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(context, category);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'category',
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'No categories yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Add your first ${categoryType} category to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, Map<String, dynamic> category) {
    final color = Color(category['color'] as int);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onEdit(category),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Category Icon
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: category['icon'] as String,
                      color: color,
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),

                // Category Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category['name'] as String,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      SizedBox(height: 0.5.h),
                      _buildCategoryDetails(context, category),
                    ],
                  ),
                ),

                // Actions
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => onEdit(category),
                      icon: CustomIconWidget(
                        iconName: 'edit',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 20,
                      ),
                      padding: EdgeInsets.all(2.w),
                    ),
                    if (category['isEditable'] == true)
                      IconButton(
                        onPressed: () => onDelete(category),
                        icon: CustomIconWidget(
                          iconName: 'delete',
                          color: AppTheme.errorLight,
                          size: 20,
                        ),
                        padding: EdgeInsets.all(2.w),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDetails(
      BuildContext context, Map<String, dynamic> category) {
    switch (categoryType) {
      case 'habits':
        return Text(
          '${category['itemCount']} habits',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        );
      case 'budget':
        final budget = category['budget'] as double? ?? 0.0;
        final spent = category['spent'] as double? ?? 0.0;
        final percentage = budget > 0 ? (spent / budget * 100).round() : 0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Budget: \$${budget.toStringAsFixed(0)} | Spent: \$${spent.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: budget > 0 ? spent / budget : 0,
                    backgroundColor:
                        Color(category['color'] as int).withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(category['color'] as int),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  '$percentage%',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ],
        );
      case 'exercises':
        return Text(
          '${category['itemCount']} exercises',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        );
      default:
        return SizedBox.shrink();
    }
  }
}
