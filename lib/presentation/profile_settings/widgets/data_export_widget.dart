import 'dart:convert';
import 'dart:html' as html if (dart.library.html) 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DataExportWidget extends StatefulWidget {
  const DataExportWidget({Key? key}) : super(key: key);

  @override
  State<DataExportWidget> createState() => _DataExportWidgetState();
}

class _DataExportWidgetState extends State<DataExportWidget> {
  bool _isExporting = false;

  // Mock user data for export
  final Map<String, dynamic> _userData = {
    "user_profile": {
      "name": "Sarah Johnson",
      "email": "sarah.johnson@email.com",
      "member_since": "2023-01-15",
      "total_habits": 12,
      "completed_workouts": 89,
      "budget_categories": 8
    },
    "habits": [
      {
        "id": 1,
        "name": "Morning Meditation",
        "category": "Wellness",
        "streak": 45,
        "completion_rate": 0.89,
        "created_date": "2024-06-01"
      },
      {
        "id": 2,
        "name": "Daily Reading",
        "category": "Learning",
        "streak": 23,
        "completion_rate": 0.76,
        "created_date": "2024-07-10"
      },
      {
        "id": 3,
        "name": "Water Intake",
        "category": "Health",
        "streak": 67,
        "completion_rate": 0.94,
        "created_date": "2024-05-20"
      }
    ],
    "budget_data": [
      {
        "month": "2024-07",
        "income": 4500.00,
        "expenses": 3200.00,
        "savings": 1300.00,
        "categories": {
          "Food": 800.00,
          "Transportation": 400.00,
          "Entertainment": 300.00,
          "Utilities": 500.00,
          "Healthcare": 200.00,
          "Shopping": 600.00,
          "Other": 400.00
        }
      },
      {
        "month": "2024-06",
        "income": 4500.00,
        "expenses": 2950.00,
        "savings": 1550.00,
        "categories": {
          "Food": 750.00,
          "Transportation": 350.00,
          "Entertainment": 250.00,
          "Utilities": 480.00,
          "Healthcare": 150.00,
          "Shopping": 520.00,
          "Other": 450.00
        }
      }
    ],
    "workouts": [
      {
        "id": 1,
        "name": "Morning Cardio",
        "type": "Cardio",
        "duration_minutes": 30,
        "calories_burned": 250,
        "date": "2024-08-04"
      },
      {
        "id": 2,
        "name": "Strength Training",
        "type": "Strength",
        "duration_minutes": 45,
        "calories_burned": 180,
        "date": "2024-08-03"
      },
      {
        "id": 3,
        "name": "Yoga Session",
        "type": "Flexibility",
        "duration_minutes": 60,
        "calories_burned": 120,
        "date": "2024-08-02"
      }
    ],
    "export_metadata": {
      "export_date": "2024-08-05",
      "export_time": "08:24:13",
      "app_version": "1.0.0",
      "data_format": "JSON"
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Export Data',
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
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
                        'Export your complete HabitFlow data including habits, budget records, and workout history.',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Export Formats',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              _buildExportOption(
                'JSON Format',
                'Complete data with full structure',
                'data_object',
                () => _exportData('json'),
              ),
              SizedBox(height: 2.h),
              _buildExportOption(
                'CSV Format',
                'Spreadsheet-friendly format',
                'table_chart',
                () => _exportData('csv'),
              ),
              SizedBox(height: 2.h),
              _buildExportOption(
                'PDF Report',
                'Formatted summary report',
                'picture_as_pdf',
                () => _exportData('pdf'),
              ),
              SizedBox(height: 4.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(3.w),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Summary',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    _buildDataSummaryRow('Habits Tracked',
                        '${(_userData["habits"] as List).length}'),
                    _buildDataSummaryRow('Budget Months',
                        '${(_userData["budget_data"] as List).length}'),
                    _buildDataSummaryRow('Workout Records',
                        '${(_userData["workouts"] as List).length}'),
                    _buildDataSummaryRow('Member Since',
                        _userData["user_profile"]["member_since"]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExportOption(
      String title, String subtitle, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: _isExporting ? null : onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow
                  .withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (_isExporting)
              SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              )
            else
              CustomIconWidget(
                iconName: 'download',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportData(String format) async {
    setState(() => _isExporting = true);

    try {
      String content;
      String filename;

      switch (format) {
        case 'json':
          content = const JsonEncoder.withIndent('  ').convert(_userData);
          filename =
              'habitflow_data_${DateTime.now().millisecondsSinceEpoch}.json';
          break;
        case 'csv':
          content = _generateCSVContent();
          filename =
              'habitflow_data_${DateTime.now().millisecondsSinceEpoch}.csv';
          break;
        case 'pdf':
          content = _generatePDFContent();
          filename =
              'habitflow_report_${DateTime.now().millisecondsSinceEpoch}.txt';
          break;
        default:
          content = const JsonEncoder.withIndent('  ').convert(_userData);
          filename =
              'habitflow_data_${DateTime.now().millisecondsSinceEpoch}.json';
      }

      await _downloadFile(content, filename);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data exported successfully as $format'),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _downloadFile(String content, String filename) async {
    if (kIsWeb) {
      final bytes = utf8.encode(content);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // For mobile platforms, this would typically save to downloads folder
      // For demo purposes, we'll show a success message
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  String _generateCSVContent() {
    final StringBuffer csv = StringBuffer();

    // Habits CSV
    csv.writeln('HABITS DATA');
    csv.writeln('Name,Category,Streak,Completion Rate,Created Date');
    for (final habit in _userData["habits"] as List) {
      csv.writeln(
          '${habit["name"]},${habit["category"]},${habit["streak"]},${habit["completion_rate"]},${habit["created_date"]}');
    }

    csv.writeln('');
    csv.writeln('BUDGET DATA');
    csv.writeln('Month,Income,Expenses,Savings');
    for (final budget in _userData["budget_data"] as List) {
      csv.writeln(
          '${budget["month"]},\$${budget["income"]},\$${budget["expenses"]},\$${budget["savings"]}');
    }

    csv.writeln('');
    csv.writeln('WORKOUT DATA');
    csv.writeln('Name,Type,Duration (min),Calories,Date');
    for (final workout in _userData["workouts"] as List) {
      csv.writeln(
          '${workout["name"]},${workout["type"]},${workout["duration_minutes"]},${workout["calories_burned"]},${workout["date"]}');
    }

    return csv.toString();
  }

  String _generatePDFContent() {
    final StringBuffer content = StringBuffer();

    content.writeln('HABITFLOW DATA REPORT');
    content.writeln('Generated on: ${DateTime.now().toString().split('.')[0]}');
    content.writeln('');

    content.writeln('USER PROFILE');
    content.writeln('Name: ${_userData["user_profile"]["name"]}');
    content.writeln('Email: ${_userData["user_profile"]["email"]}');
    content
        .writeln('Member Since: ${_userData["user_profile"]["member_since"]}');
    content.writeln('');

    content.writeln('HABITS SUMMARY');
    for (final habit in _userData["habits"] as List) {
      content.writeln(
          '• ${habit["name"]} (${habit["category"]}) - ${habit["streak"]} day streak');
    }
    content.writeln('');

    content.writeln('BUDGET SUMMARY');
    for (final budget in _userData["budget_data"] as List) {
      content.writeln(
          '${budget["month"]}: Income \$${budget["income"]}, Expenses \$${budget["expenses"]}, Savings \$${budget["savings"]}');
    }
    content.writeln('');

    content.writeln('WORKOUT SUMMARY');
    for (final workout in _userData["workouts"] as List) {
      content.writeln(
          '${workout["date"]}: ${workout["name"]} - ${workout["duration_minutes"]}min, ${workout["calories_burned"]} calories');
    }

    return content.toString();
  }
}
