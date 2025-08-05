import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryCardWidget extends StatelessWidget {
  final Map<String, dynamic> category;
  final VoidCallback onTap;

  const CategoryCardWidget({
    Key? key,
    required this.category,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spent = (category['spent'] as num).toDouble();
    final budget = (category['budget'] as num).toDouble();
    final progress = budget > 0 ? spent / budget : 0.0;
    final remaining = budget - spent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        margin: EdgeInsets.only(right: 3.w),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color:
                        Color(category['color'] as int).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: category['icon'] as String,
                    color: Color(category['color'] as int),
                    size: 5.w,
                  ),
                ),
                const Spacer(),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 4.w,
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Text(
              category['name'] as String,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 1.h),
            Text(
              '\$${spent.toStringAsFixed(0)} / \$${budget.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: 2.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress > 0.9
                      ? AppTheme.errorLight
                      : progress > 0.7
                          ? AppTheme.warningLight
                          : Color(category['color'] as int),
                ),
                minHeight: 1.h,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              remaining >= 0
                  ? '\$${remaining.toStringAsFixed(0)} left'
                  : '\$${(-remaining).toStringAsFixed(0)} over',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: remaining >= 0
                        ? AppTheme.successLight
                        : AppTheme.errorLight,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
