import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TodayHabitsCard extends StatefulWidget {
  const TodayHabitsCard({super.key});

  @override
  State<TodayHabitsCard> createState() => _TodayHabitsCardState();
}

class _TodayHabitsCardState extends State<TodayHabitsCard> {
  final List<Map<String, dynamic>> todayHabits = [
    {
      "id": 1,
      "name": "Morning Meditation",
      "icon": "self_improvement",
      "completed": true,
      "streak": 12,
      "category": "Wellness",
      "time": "7:00 AM"
    },
    {
      "id": 2,
      "name": "Drink 8 Glasses Water",
      "icon": "local_drink",
      "completed": false,
      "streak": 8,
      "category": "Health",
      "time": "Throughout day"
    },
    {
      "id": 3,
      "name": "Read 30 Minutes",
      "icon": "menu_book",
      "completed": false,
      "streak": 15,
      "category": "Learning",
      "time": "8:00 PM"
    },
    {
      "id": 4,
      "name": "Exercise",
      "icon": "fitness_center",
      "completed": true,
      "streak": 5,
      "category": "Fitness",
      "time": "6:00 AM"
    }
  ];

  void _toggleHabit(int index) {
    setState(() {
      todayHabits[index]["completed"] = !todayHabits[index]["completed"];
      if (todayHabits[index]["completed"]) {
        todayHabits[index]["streak"] =
            (todayHabits[index]["streak"] as int) + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final completedCount =
        todayHabits.where((habit) => habit["completed"] as bool).length;
    final totalCount = todayHabits.length;
    final progressPercentage = completedCount / totalCount;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: CustomIconWidget(
                    iconName: 'track_changes',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 6.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Habits",
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "$completedCount of $totalCount completed",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/habit-tracking'),
                  child: CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Container(
              width: double.infinity,
              height: 1.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(0.5.h),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progressPercentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(0.5.h),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: todayHabits.length > 3 ? 3 : todayHabits.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                final habit = todayHabits[index];
                final isCompleted = habit["completed"] as bool;

                return GestureDetector(
                  onTap: () => _toggleHabit(index),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.05)
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(2.w),
                      border: Border.all(
                        color: isCompleted
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3)
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppTheme.lightTheme.colorScheme.primary
                                : Colors.transparent,
                            border: Border.all(
                              color: isCompleted
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.outline,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(1.w),
                          ),
                          child: isCompleted
                              ? CustomIconWidget(
                                  iconName: 'check',
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  size: 4.w,
                                )
                              : null,
                        ),
                        SizedBox(width: 3.w),
                        CustomIconWidget(
                          iconName: habit["icon"] as String,
                          color: isCompleted
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 5.w,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                habit["name"] as String,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  decoration: isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: isCompleted
                                      ? AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                habit["time"] as String,
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
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.tertiary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(1.w),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'local_fire_department',
                                color: AppTheme.lightTheme.colorScheme.tertiary,
                                size: 3.w,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                "${habit["streak"]}",
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.tertiary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            if (todayHabits.length > 3) ...[
              SizedBox(height: 2.h),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/habit-tracking'),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    "View ${todayHabits.length - 3} more habits",
                    textAlign: TextAlign.center,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
