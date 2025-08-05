import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionButton extends StatelessWidget {
  const QuickActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showQuickActionBottomSheet(context),
      child: CustomIconWidget(
        iconName: 'add',
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        size: 7.w,
      ),
    );
  }

  void _showQuickActionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.w),
            topRight: Radius.circular(5.w),
          ),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(0.25.h),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              "Quick Actions",
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              "What would you like to add?",
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context,
                    "New Habit",
                    "Create a daily habit",
                    "track_changes",
                    AppTheme.lightTheme.colorScheme.primary,
                    () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/habit-tracking');
                    },
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildActionCard(
                    context,
                    "Log Expense",
                    "Track your spending",
                    "account_balance_wallet",
                    AppTheme.lightTheme.colorScheme.secondary,
                    () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/budget-planning');
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.w),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context,
                    "Start Workout",
                    "Begin exercise session",
                    "fitness_center",
                    AppTheme.lightTheme.colorScheme.tertiary,
                    () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/workout-management');
                    },
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildActionCard(
                    context,
                    "View Profile",
                    "Manage settings",
                    "person",
                    AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/profile-settings');
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    String iconName,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 8.w,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.5.h),
            Text(
              subtitle,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
