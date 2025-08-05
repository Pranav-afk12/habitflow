import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DateNavigationWidget extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;
  final VoidCallback onCalendarTap;

  const DateNavigationWidget({
    Key? key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.onCalendarTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isToday = _isToday(selectedDate);
    final formattedDate = _formatDate(selectedDate);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Day Button
          GestureDetector(
            onTap: () {
              final previousDay = selectedDate.subtract(Duration(days: 1));
              onDateChanged(previousDay);
            },
            child: Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'chevron_left',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
              ),
            ),
          ),

          // Date Display
          Expanded(
            child: GestureDetector(
              onTap: onCalendarTap,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isToday
                      ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: isToday
                      ? Border.all(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.3),
                          width: 1,
                        )
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          formattedDate['dayName']!,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: isToday
                                        ? AppTheme.lightTheme.primaryColor
                                        : Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.color,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          formattedDate['date']!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isToday
                                        ? AppTheme.lightTheme.primaryColor
                                        : Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color,
                                  ),
                        ),
                      ],
                    ),
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: 'calendar_today',
                      color: isToday
                          ? AppTheme.lightTheme.primaryColor
                          : Theme.of(context).textTheme.bodySmall?.color ??
                              Colors.grey,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Next Day Button
          GestureDetector(
            onTap: () {
              final nextDay = selectedDate.add(Duration(days: 1));
              onDateChanged(nextDay);
            },
            child: Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Map<String, String> _formatDate(DateTime date) {
    final dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final monthNames = [
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

    final dayName = dayNames[date.weekday - 1];
    final monthName = monthNames[date.month - 1];
    final formattedDate = '$monthName ${date.day}, ${date.year}';

    return {
      'dayName': dayName,
      'date': formattedDate,
    };
  }
}
