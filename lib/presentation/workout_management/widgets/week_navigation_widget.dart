import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeekNavigationWidget extends StatelessWidget {
  final DateTime currentWeek;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;

  const WeekNavigationWidget({
    Key? key,
    required this.currentWeek,
    required this.onPreviousWeek,
    required this.onNextWeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onPreviousWeek,
            icon: CustomIconWidget(
              iconName: 'chevron_left',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            padding: EdgeInsets.all(2.w),
            constraints: BoxConstraints(
              minWidth: 10.w,
              minHeight: 5.h,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  _getWeekTitle(),
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _getWeekRange(),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onNextWeek,
            icon: CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            padding: EdgeInsets.all(2.w),
            constraints: BoxConstraints(
              minWidth: 10.w,
              minHeight: 5.h,
            ),
          ),
        ],
      ),
    );
  }

  String _getWeekTitle() {
    final now = DateTime.now();
    final weekStart =
        currentWeek.subtract(Duration(days: currentWeek.weekday - 1));
    final weekEnd = weekStart.add(Duration(days: 6));

    if (_isSameWeek(now, currentWeek)) {
      return 'This Week';
    } else if (_isSameWeek(now.subtract(Duration(days: 7)), currentWeek)) {
      return 'Last Week';
    } else if (_isSameWeek(now.add(Duration(days: 7)), currentWeek)) {
      return 'Next Week';
    } else {
      return 'Week of ${_formatDate(weekStart)}';
    }
  }

  String _getWeekRange() {
    final weekStart =
        currentWeek.subtract(Duration(days: currentWeek.weekday - 1));
    final weekEnd = weekStart.add(Duration(days: 6));

    if (weekStart.month == weekEnd.month) {
      return '${_formatShortDate(weekStart)} - ${_formatShortDate(weekEnd)}';
    } else {
      return '${_formatDate(weekStart)} - ${_formatDate(weekEnd)}';
    }
  }

  bool _isSameWeek(DateTime date1, DateTime date2) {
    final week1Start = date1.subtract(Duration(days: date1.weekday - 1));
    final week2Start = date2.subtract(Duration(days: date2.weekday - 1));
    return week1Start.year == week2Start.year &&
        week1Start.month == week2Start.month &&
        week1Start.day == week2Start.day;
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatShortDate(DateTime date) {
    return '${date.day}';
  }
}
