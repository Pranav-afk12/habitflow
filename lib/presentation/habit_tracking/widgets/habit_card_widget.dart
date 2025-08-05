import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HabitCardWidget extends StatefulWidget {
  final Map<String, dynamic> habit;
  final Function(String) onToggleComplete;
  final Function(String) onEdit;
  final Function(String) onViewStats;
  final Function(String) onDelete;

  const HabitCardWidget({
    Key? key,
    required this.habit,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onViewStats,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<HabitCardWidget> createState() => _HabitCardWidgetState();
}

class _HabitCardWidgetState extends State<HabitCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.habit['isCompleted'] ?? false;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleToggleComplete() {
    setState(() {
      _isCompleted = !_isCompleted;
    });

    if (_isCompleted) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      HapticFeedback.lightImpact();
    }

    widget.onToggleComplete(widget.habit['id'].toString());
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text(
                'Edit Habit',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                widget.onEdit(widget.habit['id'].toString());
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'bar_chart',
                color: AppTheme.accentLight,
                size: 24,
              ),
              title: Text(
                'View Statistics',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                widget.onViewStats(widget.habit['id'].toString());
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.errorLight,
                size: 24,
              ),
              title: Text(
                'Delete Habit',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.errorLight,
                    ),
              ),
              onTap: () {
                Navigator.pop(context);
                widget.onDelete(widget.habit['id'].toString());
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final streak = widget.habit['streak'] ?? 0;
    final category = widget.habit['category'] ?? 'Personal';
    final categoryColor = _getCategoryColor(category);

    return Dismissible(
      key: Key(widget.habit['id'].toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 6.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'edit',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'bar_chart',
              color: AppTheme.accentLight,
              size: 24,
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'delete',
              color: AppTheme.errorLight,
              size: 24,
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        _showQuickActions();
      },
      child: GestureDetector(
        onLongPress: _showQuickActions,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
                  border: _isCompleted
                      ? Border.all(
                          color: AppTheme.successLight.withValues(alpha: 0.3),
                          width: 2,
                        )
                      : null,
                ),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Row(
                    children: [
                      // Category Icon
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: _getCategoryIcon(category),
                            color: categoryColor,
                            size: 24,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),

                      // Habit Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.habit['name'] ?? 'Unnamed Habit',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    decoration: _isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    color: _isCompleted
                                        ? Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color
                                        : Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.color,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: categoryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    category,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: categoryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                                if (streak > 0) ...[
                                  SizedBox(width: 2.w),
                                  Row(
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'local_fire_department',
                                        color: AppTheme.accentLight,
                                        size: 16,
                                      ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        '$streak',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: AppTheme.accentLight,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Completion Checkbox
                      GestureDetector(
                        onTap: _handleToggleComplete,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: _isCompleted
                                ? AppTheme.successLight
                                : Colors.transparent,
                            border: Border.all(
                              color: _isCompleted
                                  ? AppTheme.successLight
                                  : AppTheme.lightTheme.dividerColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: _isCompleted
                              ? CustomIconWidget(
                                  iconName: 'check',
                                  color: Colors.white,
                                  size: 18,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'health':
        return AppTheme.successLight;
      case 'productivity':
        return AppTheme.lightTheme.primaryColor;
      case 'learning':
        return AppTheme.accentLight;
      case 'personal':
        return AppTheme.warningLight;
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'health':
        return 'favorite';
      case 'productivity':
        return 'work';
      case 'learning':
        return 'school';
      case 'personal':
        return 'person';
      default:
        return 'star';
    }
  }
}
