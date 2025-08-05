import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_filter_widget.dart';
import './widgets/date_navigation_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/habit_card_widget.dart';
import './widgets/progress_visualization_widget.dart';

class HabitTracking extends StatefulWidget {
  const HabitTracking({Key? key}) : super(key: key);

  @override
  State<HabitTracking> createState() => _HabitTrackingState();
}

class _HabitTrackingState extends State<HabitTracking>
    with TickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'All';
  List<Map<String, dynamic>> _habits = [];
  List<Map<String, dynamic>> _filteredHabits = [];
  bool _isLoading = false;
  late TabController _tabController;

  // Mock data for habits
  final List<Map<String, dynamic>> _mockHabits = [
    {
      "id": 1,
      "name": "Morning Meditation",
      "category": "Health",
      "isCompleted": false,
      "streak": 7,
      "reminderTime": "07:00 AM",
      "description": "10 minutes of mindfulness meditation to start the day",
      "createdAt": DateTime.now().subtract(Duration(days: 7)),
    },
    {
      "id": 2,
      "name": "Read for 30 minutes",
      "category": "Learning",
      "isCompleted": true,
      "streak": 12,
      "reminderTime": "08:00 PM",
      "description": "Read books to expand knowledge and improve focus",
      "createdAt": DateTime.now().subtract(Duration(days: 12)),
    },
    {
      "id": 3,
      "name": "Drink 8 glasses of water",
      "category": "Health",
      "isCompleted": false,
      "streak": 3,
      "reminderTime": "Every 2 hours",
      "description": "Stay hydrated throughout the day for better health",
      "createdAt": DateTime.now().subtract(Duration(days: 3)),
    },
    {
      "id": 4,
      "name": "Write in journal",
      "category": "Personal",
      "isCompleted": true,
      "streak": 5,
      "reminderTime": "09:00 PM",
      "description": "Reflect on the day and practice gratitude",
      "createdAt": DateTime.now().subtract(Duration(days: 5)),
    },
    {
      "id": 5,
      "name": "Exercise for 30 minutes",
      "category": "Health",
      "isCompleted": false,
      "streak": 15,
      "reminderTime": "06:00 AM",
      "description": "Daily workout to maintain physical fitness",
      "createdAt": DateTime.now().subtract(Duration(days: 15)),
    },
    {
      "id": 6,
      "name": "Review daily goals",
      "category": "Productivity",
      "isCompleted": true,
      "streak": 8,
      "reminderTime": "09:00 AM",
      "description": "Plan and prioritize tasks for the day",
      "createdAt": DateTime.now().subtract(Duration(days: 8)),
    },
  ];

  // Mock weekly progress data
  final List<Map<String, dynamic>> _mockWeeklyData = [
    {"date": DateTime.now().subtract(Duration(days: 6)), "completionRate": 0.8},
    {"date": DateTime.now().subtract(Duration(days: 5)), "completionRate": 1.0},
    {"date": DateTime.now().subtract(Duration(days: 4)), "completionRate": 0.6},
    {"date": DateTime.now().subtract(Duration(days: 3)), "completionRate": 0.9},
    {"date": DateTime.now().subtract(Duration(days: 2)), "completionRate": 1.0},
    {"date": DateTime.now().subtract(Duration(days: 1)), "completionRate": 0.7},
    {"date": DateTime.now(), "completionRate": 0.5},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadHabits();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadHabits() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _habits = List.from(_mockHabits);
        _filterHabits();
        _isLoading = false;
      });
    });
  }

  void _filterHabits() {
    setState(() {
      if (_selectedCategory == 'All') {
        _filteredHabits = List.from(_habits);
      } else {
        _filteredHabits = _habits
            .where((habit) =>
                (habit['category'] as String).toLowerCase() ==
                _selectedCategory.toLowerCase())
            .toList();
      }
    });
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
    _loadHabits();
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterHabits();
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime.now().subtract(Duration(days: 365)),
        lastDate: DateTime.now().add(Duration(days: 30)),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context)
                      .colorScheme
                      .copyWith(primary: AppTheme.lightTheme.primaryColor)),
              child: child!);
        });

    if (picked != null && picked != _selectedDate) {
      _onDateChanged(picked);
    }
  }

  void _toggleHabitComplete(String habitId) {
    setState(() {
      final habitIndex =
          _habits.indexWhere((habit) => habit['id'].toString() == habitId);
      if (habitIndex != -1) {
        final habit = _habits[habitIndex];
        final wasCompleted = habit['isCompleted'] ?? false;

        _habits[habitIndex]['isCompleted'] = !wasCompleted;

        // Update streak
        if (!wasCompleted) {
          _habits[habitIndex]['streak'] = (habit['streak'] ?? 0) + 1;
        }
      }
    });
    _filterHabits();
  }

  void _editHabit(String habitId) {
    // Navigate to edit habit screen
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('Edit habit functionality available in Category Management'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        action: SnackBarAction(
          label: 'Go',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, '/category-management');
          },
        )));
  }

  void _viewHabitStats(String habitId) {
    final habit = _habits.firstWhere((h) => h['id'].toString() == habitId,
        orElse: () => {});

    if (habit.isNotEmpty) {
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => _buildStatsBottomSheet(habit));
    }
  }

  void _deleteHabit(String habitId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Delete Habit'),
                content: Text(
                    'Are you sure you want to delete this habit? This action cannot be undone.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel')),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _habits.removeWhere(
                              (habit) => habit['id'].toString() == habitId);
                        });
                        _filterHabits();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Habit deleted successfully'),
                            backgroundColor: AppTheme.errorLight));
                      },
                      child: Text('Delete',
                          style: TextStyle(color: AppTheme.errorLight))),
                ]));
  }

  void _createNewHabit() {
    // Navigate to create habit screen
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Create new habit functionality - Coming soon!'),
        backgroundColor: AppTheme.lightTheme.primaryColor));
  }

  Future<void> _refreshHabits() async {
    HapticFeedback.lightImpact();
    _loadHabits();
  }

  Widget _buildStatsBottomSheet(Map<String, dynamic> habit) {
    return Container(
        height: 60.h,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(children: [
          Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                  color: AppTheme.lightTheme.dividerColor,
                  borderRadius: BorderRadius.circular(2))),
          Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(habit['name'] ?? 'Habit Statistics',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    SizedBox(height: 2.h),
                    Row(children: [
                      Expanded(
                          child: _buildStatCard(
                              'Current Streak',
                              '${habit['streak'] ?? 0} days',
                              AppTheme.accentLight,
                              'local_fire_department')),
                      SizedBox(width: 2.w),
                      Expanded(
                          child: _buildStatCard(
                              'Category',
                              habit['category'] ?? 'Personal',
                              AppTheme.lightTheme.primaryColor,
                              'category')),
                    ]),
                    SizedBox(height: 2.h),
                    _buildStatCard(
                        'Description',
                        habit['description'] ?? 'No description available',
                        AppTheme.successLight,
                        'description'),
                  ])),
        ]));
  }

  Widget _buildStatCard(
      String title, String value, Color color, String iconName) {
    return Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2), width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CustomIconWidget(iconName: iconName, color: color, size: 20),
            SizedBox(width: 2.w),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: color, fontWeight: FontWeight.w500)),
          ]),
          SizedBox(height: 1.h),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: color, fontWeight: FontWeight.w600)),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
            child: Column(children: [
          // Header with Date Navigation
          DateNavigationWidget(
              selectedDate: _selectedDate,
              onDateChanged: _onDateChanged,
              onCalendarTap: _showDatePicker),

          // Category Filter
          CategoryFilterWidget(
              selectedCategory: _selectedCategory,
              onCategoryChanged: _onCategoryChanged),

          // Main Content
          Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                          color: AppTheme.lightTheme.primaryColor))
                  : _filteredHabits.isEmpty
                      ? EmptyStateWidget(onCreateHabit: _createNewHabit)
                      : RefreshIndicator(
                          onRefresh: _refreshHabits,
                          color: AppTheme.lightTheme.primaryColor,
                          child: CustomScrollView(slivers: [
                            // Progress Visualization
                            SliverToBoxAdapter(
                                child: ProgressVisualizationWidget(
                                    weeklyData: _mockWeeklyData,
                                    selectedDate: _selectedDate)),

                            // Habits List
                            SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                              final habit = _filteredHabits[index];
                              return HabitCardWidget(
                                  habit: habit,
                                  onToggleComplete: _toggleHabitComplete,
                                  onEdit: _editHabit,
                                  onViewStats: _viewHabitStats,
                                  onDelete: _deleteHabit);
                            }, childCount: _filteredHabits.length)),

                            // Bottom Padding
                            SliverToBoxAdapter(child: SizedBox(height: 10.h)),
                          ]))),
        ])),

        // Floating Action Button
        floatingActionButton: FloatingActionButton.extended(
            onPressed: _createNewHabit,
            backgroundColor: AppTheme.lightTheme.primaryColor,
            foregroundColor: Colors.white,
            icon: CustomIconWidget(
                iconName: 'add', color: Colors.white, size: 24),
            label: Text('Add Habit',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600))),

        // Bottom Navigation Bar
        bottomNavigationBar: Container(
            decoration:
                BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [
              BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: Offset(0, -2)),
            ]),
            child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.lightTheme.primaryColor,
                unselectedLabelColor:
                    Theme.of(context).textTheme.bodySmall?.color,
                indicatorColor: AppTheme.lightTheme.primaryColor,
                indicatorWeight: 3,
                tabs: [
                  Tab(
                      icon: CustomIconWidget(
                          iconName: 'track_changes',
                          color: _tabController.index == 0
                              ? AppTheme.lightTheme.primaryColor
                              : Theme.of(context).textTheme.bodySmall?.color ??
                                  Colors.grey,
                          size: 24),
                      text: 'Habits'),
                  Tab(
                      icon: CustomIconWidget(
                          iconName: 'dashboard',
                          color: _tabController.index == 1
                              ? AppTheme.lightTheme.primaryColor
                              : Theme.of(context).textTheme.bodySmall?.color ??
                                  Colors.grey,
                          size: 24),
                      text: 'Dashboard'),
                  Tab(
                      icon: CustomIconWidget(
                          iconName: 'account_balance_wallet',
                          color: _tabController.index == 2
                              ? AppTheme.lightTheme.primaryColor
                              : Theme.of(context).textTheme.bodySmall?.color ??
                                  Colors.grey,
                          size: 24),
                      text: 'Budget'),
                  Tab(
                      icon: CustomIconWidget(
                          iconName: 'fitness_center',
                          color: _tabController.index == 3
                              ? AppTheme.lightTheme.primaryColor
                              : Theme.of(context).textTheme.bodySmall?.color ??
                                  Colors.grey,
                          size: 24),
                      text: 'Workout'),
                ],
                onTap: (index) {
                  switch (index) {
                    case 0:
                      // Already on Habits tab
                      break;
                    case 1:
                      Navigator.pushNamed(context, '/main-dashboard');
                      break;
                    case 2:
                      Navigator.pushNamed(context, '/budget-planning');
                      break;
                    case 3:
                      Navigator.pushNamed(context, '/workout-management');
                      break;
                  }
                })));
  }
}
