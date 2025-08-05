import 'package:flutter/material.dart';
import '../presentation/main_dashboard/main_dashboard.dart';
import '../presentation/workout_management/workout_management.dart';
import '../presentation/budget_planning/budget_planning.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/profile_settings/profile_settings.dart';
import '../presentation/habit_tracking/habit_tracking.dart';
import '../presentation/category_management/category_management_screen.dart';
import '../presentation/currency_settings/currency_settings_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String mainDashboard = '/main-dashboard';
  static const String workoutManagement = '/workout-management';
  static const String budgetPlanning = '/budget-planning';
  static const String login = '/login-screen';
  static const String profileSettings = '/profile-settings';
  static const String habitTracking = '/habit-tracking';
  static const String categoryManagement = '/category-management';
  static const String currencySettings = '/currency-settings';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    mainDashboard: (context) => const MainDashboard(),
    workoutManagement: (context) => const WorkoutManagement(),
    budgetPlanning: (context) => const BudgetPlanning(),
    login: (context) => const LoginScreen(),
    profileSettings: (context) => const ProfileSettings(),
    habitTracking: (context) => const HabitTracking(),
    categoryManagement: (context) => const CategoryManagementScreen(),
    currencySettings: (context) => const CurrencySettingsScreen(),
    // TODO: Add your other routes here
  };
}
