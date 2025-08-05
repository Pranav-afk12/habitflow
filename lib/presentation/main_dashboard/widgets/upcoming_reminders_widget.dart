import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UpcomingRemindersWidget extends StatelessWidget {
  const UpcomingRemindersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> upcomingReminders = [
      {
        "id": 1,
        "title": "Drink Water",
        "time": "10:00 AM",
        "type": "habit",
        "icon": "local_drink",
        "color": 0xFF3498DB,
        "category": "Health"
      },
      {
        "id": 2,
        "title": "Budget Review",
        "time": "2:00 PM",
        "type": "budget",
        "icon": "account_balance_wallet",
        "color": 0xFFE67E22,
        "category": "Finance"
      },
      {
        "id": 3,
        "title": "Evening Workout",
        "time": "6:00 PM",
        "type": "workout",
        "icon": "fitness_center",
        "color": 0xFF27AE60,
        "category": "Fitness"
      },
      {
        "id": 4,
        "title": "Read Book",
        "time": "8:00 PM",
        "type": "habit",
        "icon": "menu_book",
        "color": 0xFF9B59B6,
        "category": "Learning"
      },
      {
        "id": 5,
        "title": "Weekly Budget Check",
        "time": "Tomorrow",
        "type": "budget",
        "icon": "trending_up",
        "color": 0xFFE67E22,
        "category": "Finance"
      }
    ];

    if (upcomingReminders.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'notifications',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                "Upcoming Reminders",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 12.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: upcomingReminders.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final reminder = upcomingReminders[index];

              return Container(
                width: 60.w,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(2.w),
                  border: Border.all(
                    color:
                        Color(reminder["color"] as int).withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Color(reminder["color"] as int)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(1.5.w),
                      ),
                      child: CustomIconWidget(
                        iconName: reminder["icon"] as String,
                        color: Color(reminder["color"] as int),
                        size: 5.w,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            reminder["title"] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'schedule',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 3.w,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                reminder["time"] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 1.5.w, vertical: 0.25.h),
                            decoration: BoxDecoration(
                              color: Color(reminder["color"] as int)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(0.5.w),
                            ),
                            child: Text(
                              reminder["category"] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: Color(reminder["color"] as int),
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
