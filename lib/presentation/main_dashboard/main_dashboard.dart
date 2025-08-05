import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_banner_widget.dart';
import './widgets/budget_overview_card.dart';
import './widgets/quick_action_button.dart';
import './widgets/quick_stats_widget.dart';
import './widgets/recent_workouts_card.dart';
import './widgets/today_habits_card.dart';
import './widgets/upcoming_reminders_widget.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  int _selectedIndex = 0;
  late TabController _tabController;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _navigationItems = [
    {"label": "Dashboard", "icon": "dashboard", "route": "/main-dashboard"},
    {"label": "Habits", "icon": "track_changes", "route": "/habit-tracking"},
    {
      "label": "Budget",
      "icon": "account_balance_wallet",
      "route": "/budget-planning"
    },
    {
      "label": "Workouts",
      "icon": "fitness_center",
      "route": "/workout-management"
    },
    {"label": "Profile", "icon": "person", "route": "/profile-settings"}
  ];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: _navigationItems.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _onBottomNavTap(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      _tabController.animateTo(index);

      if (index != 0) {
        Navigator.pushNamed(
            context, _navigationItems[index]["route"] as String);
      }
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return "${months[now.month - 1]} ${now.day}, ${now.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 15.h,
                floating: false,
                pinned: true,
                backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${_getGreeting()}, Alex",
                                    style: AppTheme
                                        .lightTheme.textTheme.headlineSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    _getCurrentDate(),
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, '/profile-settings'),
                              child: Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(3.w),
                                ),
                                child: CustomIconWidget(
                                  iconName: 'person',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 6.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isLoading) ...[
                      SizedBox(height: 2.h),
                      Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],

                    // Achievement Banner
                    const AchievementBannerWidget(),

                    // Quick Stats
                    const QuickStatsWidget(),

                    // Today's Habits Card
                    const TodayHabitsCard(),

                    // Budget Overview Card
                    const BudgetOverviewCard(),

                    // Recent Workouts Card
                    const RecentWorkoutsCard(),

                    // Upcoming Reminders
                    const UpcomingRemindersWidget(),

                    SizedBox(height: 10.h), // Bottom padding for FAB
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onBottomNavTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
          unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          elevation: 0,
          items: _navigationItems.map((item) {
            final index = _navigationItems.indexOf(item);
            return BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: _selectedIndex == index
                      ? AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: item["icon"] as String,
                  color: _selectedIndex == index
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
              ),
              label: item["label"] as String,
            );
          }).toList(),
        ),
      ),
      floatingActionButton:
          _selectedIndex == 0 ? const QuickActionButton() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
