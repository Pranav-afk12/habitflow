import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WorkoutCardWidget extends StatelessWidget {
  final Map<String, dynamic> workout;
  final VoidCallback onTap;
  final VoidCallback onRepeat;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  const WorkoutCardWidget({
    Key? key,
    required this.workout,
    required this.onTap,
    required this.onRepeat,
    required this.onShare,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(workout['id'].toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SizedBox(width: 4.w),
            CustomIconWidget(
              iconName: 'repeat',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              'Repeat',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 20,
            ),
            SizedBox(width: 4.w),
            CustomIconWidget(
              iconName: 'delete',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 20,
            ),
            SizedBox(width: 4.w),
          ],
        ),
      ),
      onDismissed: (direction) {
        onRepeat();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              workout['name'] as String,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              workout['date'] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _getWorkoutTypeColor(workout['type'] as String)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          workout['type'] as String,
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color:
                                _getWorkoutTypeColor(workout['type'] as String),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          icon: 'schedule',
                          label: 'Duration',
                          value: workout['duration'] as String,
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          icon: 'fitness_center',
                          label: 'Exercises',
                          value: '${workout['exerciseCount']} exercises',
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          icon: 'local_fire_department',
                          label: 'Calories',
                          value: '${workout['calories']} cal',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Exercises: ${(workout['exercises'] as List).take(3).map((e) => e['name']).join(', ')}${(workout['exercises'] as List).length > 3 ? '...' : ''}',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: _getPerformanceColor(
                                  workout['performance'] as double)
                              .withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: _getPerformanceIcon(
                              workout['performance'] as double),
                          color: _getPerformanceColor(
                              workout['performance'] as double),
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 20,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getWorkoutTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'strength':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'cardio':
        return AppTheme.lightTheme.colorScheme.error;
      case 'flexibility':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'sports':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  Color _getPerformanceColor(double performance) {
    if (performance >= 0.8) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    } else if (performance >= 0.6) {
      return Colors.orange;
    } else {
      return AppTheme.lightTheme.colorScheme.error;
    }
  }

  String _getPerformanceIcon(double performance) {
    if (performance >= 0.8) {
      return 'trending_up';
    } else if (performance >= 0.6) {
      return 'trending_flat';
    } else {
      return 'trending_down';
    }
  }
}
