import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementBannerWidget extends StatefulWidget {
  const AchievementBannerWidget({super.key});

  @override
  State<AchievementBannerWidget> createState() =>
      _AchievementBannerWidgetState();
}

class _AchievementBannerWidgetState extends State<AchievementBannerWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  bool _isVisible = true;

  final List<Map<String, dynamic>> achievements = [
    {
      "id": 1,
      "title": "7-Day Streak!",
      "description": "You've maintained your meditation habit for a week",
      "icon": "local_fire_department",
      "type": "streak",
      "color": 0xFFE67E22,
      "isNew": true
    },
    {
      "id": 2,
      "title": "Budget Master",
      "description": "Stayed under budget for 3 consecutive months",
      "icon": "star",
      "type": "budget",
      "color": 0xFFF39C12,
      "isNew": true
    },
    {
      "id": 3,
      "title": "Fitness Enthusiast",
      "description": "Completed 20 workouts this month",
      "icon": "emoji_events",
      "type": "workout",
      "color": 0xFF27AE60,
      "isNew": false
    }
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismissBanner() {
    setState(() {
      _isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final newAchievements = achievements
        .where((achievement) => achievement["isNew"] as bool)
        .toList();

    if (!_isVisible || newAchievements.isEmpty) {
      return SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    newAchievements.length > 2 ? 2 : newAchievements.length,
                separatorBuilder: (context, index) => SizedBox(height: 1.h),
                itemBuilder: (context, index) {
                  final achievement = newAchievements[index];

                  return Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(achievement["color"] as int)
                              .withValues(alpha: 0.1),
                          Color(achievement["color"] as int)
                              .withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(3.w),
                      border: Border.all(
                        color: Color(achievement["color"] as int)
                            .withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(achievement["color"] as int)
                              .withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: Color(achievement["color"] as int)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          child: CustomIconWidget(
                            iconName: achievement["icon"] as String,
                            color: Color(achievement["color"] as int),
                            size: 7.w,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 0.5.h),
                                    decoration: BoxDecoration(
                                      color: Color(achievement["color"] as int),
                                      borderRadius: BorderRadius.circular(1.w),
                                    ),
                                    child: Text(
                                      "NEW",
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    achievement["title"] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.titleSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Color(achievement["color"] as int),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                achievement["description"] as String,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _dismissBanner,
                          child: Container(
                            padding: EdgeInsets.all(1.w),
                            decoration: BoxDecoration(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(1.w),
                            ),
                            child: CustomIconWidget(
                              iconName: 'close',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 4.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
