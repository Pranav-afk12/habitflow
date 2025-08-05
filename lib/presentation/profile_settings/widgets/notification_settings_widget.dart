import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './toggle_settings_row_widget.dart';

class NotificationSettingsWidget extends StatefulWidget {
  const NotificationSettingsWidget({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsWidget> createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends State<NotificationSettingsWidget> {
  bool _habitReminders = true;
  bool _budgetAlerts = true;
  bool _workoutReminders = false;
  bool _achievementNotifications = true;
  bool _weeklyReports = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 2.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(3.w),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow
                        .withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ToggleSettingsRowWidget(
                    title: 'Habit Reminders',
                    subtitle: 'Daily reminders for your habits',
                    iconName: 'notifications',
                    value: _habitReminders,
                    onChanged: (value) =>
                        setState(() => _habitReminders = value),
                  ),
                  ToggleSettingsRowWidget(
                    title: 'Budget Alerts',
                    subtitle: 'Spending limit and budget notifications',
                    iconName: 'account_balance_wallet',
                    value: _budgetAlerts,
                    onChanged: (value) => setState(() => _budgetAlerts = value),
                  ),
                  ToggleSettingsRowWidget(
                    title: 'Workout Reminders',
                    subtitle: 'Exercise schedule notifications',
                    iconName: 'fitness_center',
                    value: _workoutReminders,
                    onChanged: (value) =>
                        setState(() => _workoutReminders = value),
                  ),
                  ToggleSettingsRowWidget(
                    title: 'Achievement Notifications',
                    subtitle: 'Celebrate your milestones',
                    iconName: 'emoji_events',
                    value: _achievementNotifications,
                    onChanged: (value) =>
                        setState(() => _achievementNotifications = value),
                  ),
                  ToggleSettingsRowWidget(
                    title: 'Weekly Reports',
                    subtitle: 'Progress summary every week',
                    iconName: 'assessment',
                    value: _weeklyReports,
                    onChanged: (value) =>
                        setState(() => _weeklyReports = value),
                    showDivider: false,
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(3.w),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Notifications help you stay on track with your goals. You can customize timing in each module.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
