import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/exercise_library_widget.dart';
import './widgets/progress_chart_widget.dart';
import './widgets/week_navigation_widget.dart';
import './widgets/workout_card_widget.dart';

class WorkoutManagement extends StatefulWidget {
  const WorkoutManagement({Key? key}) : super(key: key);

  @override
  State<WorkoutManagement> createState() => _WorkoutManagementState();
}

class _WorkoutManagementState extends State<WorkoutManagement>
    with TickerProviderStateMixin {
  DateTime currentWeek = DateTime.now();
  bool isLoading = false;
  String selectedFilter = 'All';
  late TabController _tabController;

  final List<String> filterOptions = [
    'All',
    'Strength',
    'Cardio',
    'Flexibility',
    'Sports'
  ];

  final List<Map<String, dynamic>> workoutHistory = [
    {
      "id": 1,
      "name": "Upper Body Strength",
      "date": "Today, 8:30 AM",
      "duration": "45 min",
      "type": "Strength",
      "exerciseCount": 6,
      "calories": 320,
      "performance": 0.85,
      "exercises": [
        {"name": "Push-ups", "sets": 3, "reps": 15},
        {"name": "Pull-ups", "sets": 3, "reps": 8},
        {"name": "Bench Press", "sets": 4, "reps": 10},
        {"name": "Shoulder Press", "sets": 3, "reps": 12},
        {"name": "Bicep Curls", "sets": 3, "reps": 15},
        {"name": "Tricep Dips", "sets": 3, "reps": 12}
      ]
    },
    {
      "id": 2,
      "name": "Morning Run",
      "date": "Yesterday, 6:00 AM",
      "duration": "30 min",
      "type": "Cardio",
      "exerciseCount": 1,
      "calories": 280,
      "performance": 0.92,
      "exercises": [
        {"name": "Running", "distance": "5 km", "pace": "6:00 min/km"}
      ]
    },
    {
      "id": 3,
      "name": "Leg Day",
      "date": "Dec 3, 7:00 PM",
      "duration": "55 min",
      "type": "Strength",
      "exerciseCount": 5,
      "calories": 380,
      "performance": 0.78,
      "exercises": [
        {"name": "Squats", "sets": 4, "reps": 12},
        {"name": "Deadlifts", "sets": 4, "reps": 8},
        {"name": "Lunges", "sets": 3, "reps": 10},
        {"name": "Calf Raises", "sets": 3, "reps": 20},
        {"name": "Leg Press", "sets": 3, "reps": 15}
      ]
    },
    {
      "id": 4,
      "name": "Yoga Flow",
      "date": "Dec 2, 9:00 AM",
      "duration": "40 min",
      "type": "Flexibility",
      "exerciseCount": 8,
      "calories": 150,
      "performance": 0.88,
      "exercises": [
        {"name": "Sun Salutation", "duration": "5 min"},
        {"name": "Warrior Pose", "duration": "3 min"},
        {"name": "Tree Pose", "duration": "2 min"},
        {"name": "Downward Dog", "duration": "4 min"},
        {"name": "Child's Pose", "duration": "3 min"},
        {"name": "Cobra Pose", "duration": "2 min"},
        {"name": "Pigeon Pose", "duration": "4 min"},
        {"name": "Savasana", "duration": "10 min"}
      ]
    },
    {
      "id": 5,
      "name": "HIIT Circuit",
      "date": "Dec 1, 6:30 PM",
      "duration": "25 min",
      "type": "Cardio",
      "exerciseCount": 4,
      "calories": 250,
      "performance": 0.75,
      "exercises": [
        {"name": "Burpees", "sets": 4, "reps": 10},
        {"name": "Mountain Climbers", "sets": 4, "duration": "30 sec"},
        {"name": "Jump Squats", "sets": 4, "reps": 15},
        {"name": "High Knees", "sets": 4, "duration": "30 sec"}
      ]
    }
  ];

  final List<Map<String, dynamic>> chartData = [
    {"day": "Mon", "workouts": 1, "duration": 45, "calories": 320},
    {"day": "Tue", "workouts": 0, "duration": 0, "calories": 0},
    {"day": "Wed", "workouts": 1, "duration": 30, "calories": 280},
    {"day": "Thu", "workouts": 0, "duration": 0, "calories": 0},
    {"day": "Fri", "workouts": 1, "duration": 55, "calories": 380},
    {"day": "Sat", "workouts": 1, "duration": 40, "calories": 150},
    {"day": "Sun", "workouts": 1, "duration": 25, "calories": 250}
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            WeekNavigationWidget(
              currentWeek: currentWeek,
              onPreviousWeek: _goToPreviousWeek,
              onNextWeek: _goToNextWeek,
            ),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildWorkoutHistoryTab(),
                  _buildProgressTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Workout Management',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Track your fitness journey',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: _showExerciseLibrary,
                icon: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                padding: EdgeInsets.all(2.w),
              ),
              SizedBox(width: 2.w),
              ElevatedButton(
                onPressed: _startWorkout,
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'play_arrow',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 18,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Start',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'history',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 18,
                ),
                SizedBox(width: 2.w),
                Text('History'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'trending_up',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 18,
                ),
                SizedBox(width: 2.w),
                Text('Progress'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutHistoryTab() {
    return RefreshIndicator(
      onRefresh: _refreshWorkoutData,
      child: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: _buildWorkoutList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 2.h),
          ProgressChartWidget(
            chartData: chartData,
            chartType: 'weekly',
          ),
          SizedBox(height: 2.h),
          _buildWeeklyStats(),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: filterOptions.length,
        itemBuilder: (context, index) {
          final filter = filterOptions[index];
          final isSelected = selectedFilter == filter;

          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedFilter = filter;
                });
              },
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              selectedColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
              labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              side: BorderSide(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWorkoutList() {
    final filteredWorkouts = workoutHistory.where((workout) {
      return selectedFilter == 'All' ||
          (workout['type'] as String) == selectedFilter;
    }).toList();

    if (filteredWorkouts.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 10.h),
      itemCount: filteredWorkouts.length,
      itemBuilder: (context, index) {
        final workout = filteredWorkouts[index];
        return WorkoutCardWidget(
          workout: workout,
          onTap: () => _viewWorkoutDetails(workout),
          onRepeat: () => _repeatWorkout(workout),
          onShare: () => _shareWorkout(workout),
          onDelete: () => _deleteWorkout(workout),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'fitness_center',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 3.h),
          Text(
            'No workouts yet',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Start your fitness journey today!\nTap the + button to create your first workout.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          ElevatedButton.icon(
            onPressed: _startWorkout,
            icon: CustomIconWidget(
              iconName: 'add',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 20,
            ),
            label: Text('Start First Workout'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyStats() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Week\'s Summary',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn(
                icon: 'fitness_center',
                value: '5',
                label: 'Workouts',
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              _buildStatColumn(
                icon: 'schedule',
                value: '3h 15m',
                label: 'Total Time',
                color: AppTheme.lightTheme.colorScheme.secondary,
              ),
              _buildStatColumn(
                icon: 'local_fire_department',
                value: '1,380',
                label: 'Calories',
                color: AppTheme.lightTheme.colorScheme.error,
              ),
              _buildStatColumn(
                icon: 'trending_up',
                value: '82%',
                label: 'Avg Score',
                color: AppTheme.lightTheme.colorScheme.tertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn({
    required String icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: color,
            size: 24,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _createRoutine,
      icon: CustomIconWidget(
        iconName: 'add',
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        size: 24,
      ),
      label: Text(
        'Create Routine',
        style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
    );
  }

  void _goToPreviousWeek() {
    setState(() {
      currentWeek = currentWeek.subtract(Duration(days: 7));
    });
  }

  void _goToNextWeek() {
    setState(() {
      currentWeek = currentWeek.add(Duration(days: 7));
    });
  }

  Future<void> _refreshWorkoutData() async {
    setState(() {
      isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Workout data refreshed'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _startWorkout() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting new workout...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _createRoutine() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening workout routine builder...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showExerciseLibrary() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExerciseLibraryWidget(
        onClose: () => Navigator.pop(context),
        onManageCategories: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/category-management');
        },
      ),
    );
  }

  void _viewWorkoutDetails(Map<String, dynamic> workout) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing details for ${workout['name']}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _repeatWorkout(Map<String, dynamic> workout) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Repeating workout: ${workout['name']}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareWorkout(Map<String, dynamic> workout) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing workout: ${workout['name']}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteWorkout(Map<String, dynamic> workout) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Workout'),
          content:
              Text('Are you sure you want to delete "${workout['name']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  workoutHistory.removeWhere((w) => w['id'] == workout['id']);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Workout deleted'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                'Delete',
                style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
