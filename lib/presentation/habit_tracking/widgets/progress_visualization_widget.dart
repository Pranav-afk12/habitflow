import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressVisualizationWidget extends StatelessWidget {
  final List<Map<String, dynamic>> weeklyData;
  final DateTime selectedDate;

  const ProgressVisualizationWidget({
    Key? key,
    required this.weeklyData,
    required this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Progress',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_calculateCompletionRate()}%',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Weekly Calendar Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _buildWeeklyCalendar(context),
          ),
          SizedBox(height: 2.h),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(
                context,
                AppTheme.successLight,
                'Completed',
              ),
              SizedBox(width: 4.w),
              _buildLegendItem(
                context,
                AppTheme.lightTheme.dividerColor,
                'Missed',
              ),
              SizedBox(width: 4.w),
              _buildLegendItem(
                context,
                AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                'Today',
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWeeklyCalendar(BuildContext context) {
    final weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final today = DateTime.now();
    final startOfWeek =
        selectedDate.subtract(Duration(days: selectedDate.weekday - 1));

    return List.generate(7, (index) {
      final date = startOfWeek.add(Duration(days: index));
      final isToday = date.day == today.day &&
          date.month == today.month &&
          date.year == today.year;
      final dayData = weeklyData.firstWhere(
        (data) => (data['date'] as DateTime).day == date.day,
        orElse: () => {'completionRate': 0.0, 'date': date},
      );
      final completionRate = (dayData['completionRate'] as double?) ?? 0.0;

      return Column(
        children: [
          Text(
            weekDays[index],
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 1.h),
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: _getDateColor(completionRate, isToday),
              borderRadius: BorderRadius.circular(4.w),
              border: isToday
                  ? Border.all(
                      color: AppTheme.lightTheme.primaryColor,
                      width: 2,
                    )
                  : null,
            ),
            child: Center(
              child: completionRate >= 1.0
                  ? CustomIconWidget(
                      iconName: 'check',
                      color: Colors.white,
                      size: 14,
                    )
                  : Text(
                      date.day.toString(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: _getTextColor(completionRate, isToday),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildLegendItem(BuildContext context, Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1.5.w),
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
        ),
      ],
    );
  }

  Color _getDateColor(double completionRate, bool isToday) {
    if (completionRate >= 1.0) {
      return AppTheme.successLight;
    } else if (completionRate > 0.0) {
      return AppTheme.warningLight.withValues(alpha: 0.7);
    } else if (isToday) {
      return AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3);
    } else {
      return AppTheme.lightTheme.dividerColor;
    }
  }

  Color _getTextColor(double completionRate, bool isToday) {
    if (completionRate >= 1.0) {
      return Colors.white;
    } else if (isToday) {
      return AppTheme.lightTheme.primaryColor;
    } else {
      return AppTheme.textSecondaryLight;
    }
  }

  int _calculateCompletionRate() {
    if (weeklyData.isEmpty) return 0;

    final totalRate = weeklyData.fold<double>(
      0.0,
      (sum, data) => sum + ((data['completionRate'] as double?) ?? 0.0),
    );

    return ((totalRate / weeklyData.length) * 100).round();
  }
}
