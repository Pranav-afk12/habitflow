import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickStatsWidget extends StatelessWidget {
  const QuickStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> weeklyStats = {
      "habits": {
        "completed": 18,
        "total": 21,
        "percentage": 85.7,
        "trend": "up",
        "icon": "track_changes",
        "color": 0xFF2D5A4A
      },
      "budget": {
        "saved": 450.0,
        "target": 500.0,
        "percentage": 90.0,
        "trend": "up",
        "icon": "savings",
        "color": 0xFFE67E22
      },
      "workouts": {
        "completed": 4,
        "target": 5,
        "percentage": 80.0,
        "trend": "stable",
        "icon": "fitness_center",
        "color": 0xFF27AE60
      }
    };

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
            child: Text(
              "Weekly Progress",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  "Habits",
                  "${weeklyStats["habits"]["completed"]}/${weeklyStats["habits"]["total"]}",
                  "${weeklyStats["habits"]["percentage"].toStringAsFixed(0)}%",
                  weeklyStats["habits"]["icon"] as String,
                  Color(weeklyStats["habits"]["color"] as int),
                  weeklyStats["habits"]["trend"] as String,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildStatCard(
                  context,
                  "Saved",
                  "\$${weeklyStats["budget"]["saved"].toStringAsFixed(0)}",
                  "${weeklyStats["budget"]["percentage"].toStringAsFixed(0)}%",
                  weeklyStats["budget"]["icon"] as String,
                  Color(weeklyStats["budget"]["color"] as int),
                  weeklyStats["budget"]["trend"] as String,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildStatCard(
                  context,
                  "Workouts",
                  "${weeklyStats["workouts"]["completed"]}/${weeklyStats["workouts"]["target"]}",
                  "${weeklyStats["workouts"]["percentage"].toStringAsFixed(0)}%",
                  weeklyStats["workouts"]["icon"] as String,
                  Color(weeklyStats["workouts"]["color"] as int),
                  weeklyStats["workouts"]["trend"] as String,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    String percentage,
    String iconName,
    Color color,
    String trend,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
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
              Container(
                padding: EdgeInsets.all(1.5.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(1.w),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: color,
                  size: 4.w,
                ),
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getTrendColor(trend).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(0.5.w),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: _getTrendIcon(trend),
                      color: _getTrendColor(trend),
                      size: 2.5.w,
                    ),
                    SizedBox(width: 0.5.w),
                    Text(
                      percentage,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: _getTrendColor(trend),
                        fontWeight: FontWeight.w600,
                        fontSize: 9.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case 'up':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'down':
        return AppTheme.lightTheme.colorScheme.error;
      case 'stable':
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getTrendIcon(String trend) {
    switch (trend) {
      case 'up':
        return 'trending_up';
      case 'down':
        return 'trending_down';
      case 'stable':
      default:
        return 'trending_flat';
    }
  }
}
