import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExerciseLibraryWidget extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onManageCategories;

  const ExerciseLibraryWidget({
    Key? key,
    required this.onClose,
    this.onManageCategories,
  }) : super(key: key);

  @override
  State<ExerciseLibraryWidget> createState() => _ExerciseLibraryWidgetState();
}

class _ExerciseLibraryWidgetState extends State<ExerciseLibraryWidget> {
  String selectedCategory = 'All';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> categories = [
    'All',
    'Strength',
    'Cardio',
    'Flexibility',
    'Sports'
  ];

  final List<Map<String, dynamic>> exercises = [
    {
      "id": 1,
      "name": "Push-ups",
      "category": "Strength",
      "muscleGroups": ["Chest", "Shoulders", "Triceps"],
      "difficulty": "Beginner",
      "equipment": "None",
      "description":
          "A classic bodyweight exercise that targets the chest, shoulders, and triceps.",
      "image":
          "https://images.pexels.com/photos/416809/pexels-photo-416809.jpeg?auto=compress&cs=tinysrgb&w=400",
      "duration": "3 sets x 10-15 reps"
    },
    {
      "id": 2,
      "name": "Squats",
      "category": "Strength",
      "muscleGroups": ["Quadriceps", "Glutes", "Hamstrings"],
      "difficulty": "Beginner",
      "equipment": "None",
      "description":
          "A fundamental lower body exercise that strengthens the legs and glutes.",
      "image":
          "https://images.pexels.com/photos/703012/pexels-photo-703012.jpeg?auto=compress&cs=tinysrgb&w=400",
      "duration": "3 sets x 12-20 reps"
    },
    {
      "id": 3,
      "name": "Running",
      "category": "Cardio",
      "muscleGroups": ["Legs", "Core"],
      "difficulty": "Intermediate",
      "equipment": "None",
      "description":
          "Cardiovascular exercise that improves endurance and burns calories.",
      "image":
          "https://images.pexels.com/photos/2402777/pexels-photo-2402777.jpeg?auto=compress&cs=tinysrgb&w=400",
      "duration": "20-45 minutes"
    },
    {
      "id": 4,
      "name": "Yoga Flow",
      "category": "Flexibility",
      "muscleGroups": ["Full Body"],
      "difficulty": "Beginner",
      "equipment": "Yoga Mat",
      "description":
          "A series of flowing yoga poses that improve flexibility and mindfulness.",
      "image":
          "https://images.pexels.com/photos/3822622/pexels-photo-3822622.jpeg?auto=compress&cs=tinysrgb&w=400",
      "duration": "30-60 minutes"
    },
    {
      "id": 5,
      "name": "Deadlifts",
      "category": "Strength",
      "muscleGroups": ["Hamstrings", "Glutes", "Back"],
      "difficulty": "Advanced",
      "equipment": "Barbell",
      "description":
          "A compound exercise that targets multiple muscle groups in the posterior chain.",
      "image":
          "https://images.pexels.com/photos/1552242/pexels-photo-1552242.jpeg?auto=compress&cs=tinysrgb&w=400",
      "duration": "4 sets x 6-8 reps"
    },
    {
      "id": 6,
      "name": "Burpees",
      "category": "Cardio",
      "muscleGroups": ["Full Body"],
      "difficulty": "Intermediate",
      "equipment": "None",
      "description":
          "High-intensity full-body exercise that combines strength and cardio.",
      "image":
          "https://images.pexels.com/photos/4162449/pexels-photo-4162449.jpeg?auto=compress&cs=tinysrgb&w=400",
      "duration": "3 sets x 8-12 reps"
    },
    {
      "id": 7,
      "name": "Basketball",
      "category": "Sports",
      "muscleGroups": ["Legs", "Core", "Arms"],
      "difficulty": "Intermediate",
      "equipment": "Basketball",
      "description":
          "Team sport that provides excellent cardiovascular exercise and coordination training.",
      "image":
          "https://images.pexels.com/photos/1752757/pexels-photo-1752757.jpeg?auto=compress&cs=tinysrgb&w=400",
      "duration": "45-90 minutes"
    },
    {
      "id": 8,
      "name": "Plank",
      "category": "Strength",
      "muscleGroups": ["Core", "Shoulders"],
      "difficulty": "Beginner",
      "equipment": "None",
      "description":
          "Isometric core exercise that builds stability and strength.",
      "image":
          "https://images.pexels.com/photos/4162451/pexels-photo-4162451.jpeg?auto=compress&cs=tinysrgb&w=400",
      "duration": "3 sets x 30-60 seconds"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildCategoryFilters(),
          Expanded(
            child: _buildExerciseList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
          Text(
            'Exercise Library',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              if (widget.onManageCategories != null)
                IconButton(
                  onPressed: widget.onManageCategories,
                  icon: CustomIconWidget(
                    iconName: 'settings',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  padding: EdgeInsets.all(2.w),
                ),
              IconButton(
                onPressed: widget.onClose,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
                padding: EdgeInsets.all(2.w),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(4.w),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            searchQuery = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: 'Search exercises...',
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      searchQuery = '';
                    });
                  },
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Container(
      height: 6.h,
      margin: EdgeInsets.only(bottom: 2.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedCategory = category;
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

  Widget _buildExerciseList() {
    final filteredExercises = exercises.where((exercise) {
      final matchesCategory = selectedCategory == 'All' ||
          (exercise['category'] as String) == selectedCategory;
      final matchesSearch = searchQuery.isEmpty ||
          (exercise['name'] as String).toLowerCase().contains(searchQuery) ||
          (exercise['muscleGroups'] as List).any((muscle) =>
              (muscle as String).toLowerCase().contains(searchQuery));

      return matchesCategory && matchesSearch;
    }).toList();

    return filteredExercises.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: filteredExercises.length,
            itemBuilder: (context, index) {
              final exercise = filteredExercises[index];
              return _buildExerciseCard(exercise);
            },
          );
  }

  Widget _buildExerciseCard(Map<String, dynamic> exercise) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle exercise selection
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: exercise['image'] as String,
                    width: 20.w,
                    height: 15.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              exercise['name'] as String,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor(
                                      exercise['difficulty'] as String)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              exercise['difficulty'] as String,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: _getDifficultyColor(
                                    exercise['difficulty'] as String),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        exercise['description'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 14,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            exercise['duration'] as String,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Wrap(
                        spacing: 1.w,
                        children: (exercise['muscleGroups'] as List)
                            .take(3)
                            .map((muscle) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.2.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.secondary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              muscle as String,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                                fontSize: 9,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No exercises found',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Try adjusting your search or filters',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
