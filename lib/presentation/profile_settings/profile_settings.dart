import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/data_export_widget.dart';
import './widgets/notification_settings_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_row_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/theme_selection_widget.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  // Mock user data
  final Map<String, dynamic> _userData = {
    "name": "Sarah Johnson",
    "email": "sarah.johnson@email.com",
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face",
    "membershipDuration": "8 months",
    "joinDate": "2024-01-15",
    "totalHabits": 12,
    "completedWorkouts": 89,
    "budgetCategories": 8,
    "currentStreak": 45
  };

  // Settings state
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _darkModeEnabled = false;
  String _selectedTheme = 'light';
  String _selectedUnits = 'imperial';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              ProfileHeaderWidget(
                userName: _userData["name"] as String,
                membershipDuration: _userData["membershipDuration"] as String,
                avatarUrl: _userData["avatar"] as String,
                onEditProfile: _showEditProfileDialog,
                onAvatarTap: _showAvatarOptions,
              ),

              SizedBox(height: 2.h),

              // Account Section
              SettingsSectionWidget(
                title: 'Account',
                children: [
                  SettingsRowWidget(
                    title: 'Edit Profile',
                    subtitle: 'Update your personal information',
                    iconName: 'person',
                    onTap: _showEditProfileDialog,
                  ),
                  SettingsRowWidget(
                    title: 'Change Password',
                    subtitle: 'Update your account password',
                    iconName: 'lock',
                    onTap: _showChangePasswordDialog,
                  ),
                  SettingsRowWidget(
                    title: 'Biometric Settings',
                    subtitle: _biometricEnabled
                        ? 'Face ID enabled'
                        : 'Not configured',
                    iconName: 'fingerprint',
                    onTap: _showBiometricSettings,
                    showDivider: false,
                  ),
                ],
              ),

              // Preferences Section
              SettingsSectionWidget(
                title: 'Preferences',
                children: [
                  SettingsRowWidget(
                    title: 'Notifications',
                    subtitle: _notificationsEnabled ? 'Enabled' : 'Disabled',
                    iconName: 'notifications',
                    onTap: () => _navigateToNotificationSettings(),
                  ),
                  SettingsRowWidget(
                    title: 'Theme',
                    subtitle: _getThemeDisplayName(_selectedTheme),
                    iconName: 'palette',
                    onTap: _showThemeSelection,
                  ),
                  SettingsRowWidget(
                    title: 'Units',
                    subtitle: _selectedUnits == 'imperial'
                        ? 'Imperial (lbs, ft)'
                        : 'Metric (kg, cm)',
                    iconName: 'straighten',
                    onTap: _showUnitsSelection,
                    showDivider: false,
                  ),
                ],
              ),

              // Data Section
              SettingsSectionWidget(
                title: 'Data',
                children: [
                  SettingsRowWidget(
                    title: 'Export Data',
                    subtitle: 'Download your complete data',
                    iconName: 'download',
                    onTap: () => _navigateToDataExport(),
                  ),
                  SettingsRowWidget(
                    title: 'Backup & Sync',
                    subtitle: 'Cloud backup settings',
                    iconName: 'cloud_upload',
                    onTap: _showBackupSettings,
                  ),
                  SettingsRowWidget(
                    title: 'Data Usage',
                    subtitle: 'View storage and usage stats',
                    iconName: 'storage',
                    onTap: _showDataUsage,
                    showDivider: false,
                  ),
                ],
              ),

              // Support Section
              SettingsSectionWidget(
                title: 'Support',
                children: [
                  SettingsRowWidget(
                    title: 'Help Center',
                    subtitle: 'FAQs and guides',
                    iconName: 'help',
                    onTap: _openHelpCenter,
                  ),
                  SettingsRowWidget(
                    title: 'Send Feedback',
                    subtitle: 'Help us improve HabitFlow',
                    iconName: 'feedback',
                    onTap: _showFeedbackDialog,
                  ),
                  SettingsRowWidget(
                    title: 'About',
                    subtitle: 'Version 1.0.0',
                    iconName: 'info',
                    onTap: _showAboutDialog,
                    showDivider: false,
                  ),
                ],
              ),

              // Danger Zone
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Text(
                        'Danger Zone',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(3.w),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.error
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: SettingsRowWidget(
                        title: 'Delete Account',
                        subtitle: 'Permanently delete your account',
                        iconName: 'delete_forever',
                        onTap: _showDeleteAccountDialog,
                        showDivider: false,
                        trailing: CustomIconWidget(
                          iconName: 'warning',
                          color: AppTheme.lightTheme.colorScheme.error,
                          size: 5.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Footer
              Container(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    Text(
                      'HabitFlow v1.0.0',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _openPrivacyPolicy,
                          child: Text(
                            'Privacy Policy',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Text(
                          ' • ',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        GestureDetector(
                          onTap: _openTermsOfService,
                          child: Text(
                            'Terms of Service',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: _userData["name"],
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: _userData["email"],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Profile updated successfully');
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 1.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Change Profile Photo',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAvatarOption('Camera', 'camera_alt', () {
                  Navigator.pop(context);
                  _showSuccessMessage('Photo captured successfully');
                }),
                _buildAvatarOption('Gallery', 'photo_library', () {
                  Navigator.pop(context);
                  _showSuccessMessage('Photo selected from gallery');
                }),
                _buildAvatarOption('Remove', 'delete', () {
                  Navigator.pop(context);
                  _showSuccessMessage('Profile photo removed');
                }),
              ],
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarOption(String title, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                suffixIcon: CustomIconWidget(
                  iconName: 'visibility_off',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                suffixIcon: CustomIconWidget(
                  iconName: 'visibility_off',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                suffixIcon: CustomIconWidget(
                  iconName: 'visibility_off',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Password changed successfully');
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showBiometricSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'fingerprint',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text('Biometric Authentication'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enable biometric authentication to secure your HabitFlow data with Face ID, Touch ID, or fingerprint.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Enable Biometric Login',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Switch(
                  value: _biometricEnabled,
                  onChanged: (value) {
                    setState(() => _biometricEnabled = value);
                    Navigator.pop(context);
                    _showSuccessMessage(value
                        ? 'Biometric authentication enabled'
                        : 'Biometric authentication disabled');
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _navigateToNotificationSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationSettingsWidget(),
      ),
    );
  }

  void _showThemeSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => const ThemeSelectionWidget(),
    ).then((selectedTheme) {
      if (selectedTheme != null) {
        setState(() => _selectedTheme = selectedTheme);
        _showSuccessMessage(
            'Theme updated to ${_getThemeDisplayName(selectedTheme)}');
      }
    });
  }

  String _getThemeDisplayName(String theme) {
    switch (theme) {
      case 'light':
        return 'Light Mode';
      case 'dark':
        return 'Dark Mode';
      case 'system':
        return 'System Default';
      default:
        return 'Light Mode';
    }
  }

  void _showUnitsSelection() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Measurement Units'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('Imperial (lbs, ft, in)'),
              value: 'imperial',
              groupValue: _selectedUnits,
              onChanged: (value) {
                setState(() => _selectedUnits = value!);
                Navigator.pop(context);
                _showSuccessMessage('Units changed to Imperial');
              },
            ),
            RadioListTile<String>(
              title: Text('Metric (kg, cm)'),
              value: 'metric',
              groupValue: _selectedUnits,
              onChanged: (value) {
                setState(() => _selectedUnits = value!);
                Navigator.pop(context);
                _showSuccessMessage('Units changed to Metric');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _navigateToDataExport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DataExportWidget(),
      ),
    );
  }

  void _showBackupSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'cloud_upload',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text('Backup & Sync'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Automatically backup your data to the cloud and sync across devices.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Cloud sync will be available in a future update.',
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDataUsage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Data Usage'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildUsageRow('Habits Data', '2.4 MB'),
            _buildUsageRow('Budget Records', '1.8 MB'),
            _buildUsageRow('Workout Logs', '3.2 MB'),
            _buildUsageRow('Media Files', '15.6 MB'),
            Divider(),
            _buildUsageRow('Total Storage', '23.0 MB', isTotal: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: isTotal
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  void _openHelpCenter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Help Center'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get help with HabitFlow features:',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            _buildHelpItem('Getting Started Guide'),
            _buildHelpItem('Habit Tracking Tips'),
            _buildHelpItem('Budget Planning Help'),
            _buildHelpItem('Workout Management'),
            _buildHelpItem('Troubleshooting'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Opening help center...');
            },
            child: Text('Visit Help Center'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'help_outline',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 4.w,
          ),
          SizedBox(width: 2.w),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Send Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Your Feedback',
                hintText: 'Tell us what you think about HabitFlow...',
                alignLabelWithHint: true,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Checkbox(value: false, onChanged: (value) {}),
                Expanded(
                  child: Text(
                    'Include app usage data',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Feedback sent successfully');
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: CustomIconWidget(
                iconName: 'track_changes',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 6.w,
              ),
            ),
            SizedBox(width: 3.w),
            Text('About HabitFlow'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HabitFlow v1.0.0',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Your comprehensive companion for building better habits, managing budgets, and tracking fitness progress.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Text(
              '© 2024 HabitFlow. All rights reserved.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Delete Account',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action cannot be undone. All your data will be permanently deleted:',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Text('• All habit tracking data',
                style: AppTheme.lightTheme.textTheme.bodySmall),
            Text('• Budget and expense records',
                style: AppTheme.lightTheme.textTheme.bodySmall),
            Text('• Workout history and progress',
                style: AppTheme.lightTheme.textTheme.bodySmall),
            Text('• Account settings and preferences',
                style: AppTheme.lightTheme.textTheme.bodySmall),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Type "DELETE" to confirm',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Account deletion cancelled');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  void _openPrivacyPolicy() {
    _showSuccessMessage('Opening Privacy Policy...');
  }

  void _openTermsOfService() {
    _showSuccessMessage('Opening Terms of Service...');
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.w),
        ),
      ),
    );
  }
}
