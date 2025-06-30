import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';

class HabitProvider with ChangeNotifier {
  List<Habit> _habits = [];
  bool _isLoading = true;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;

  // Get today's habits
  List<Habit> get todayHabits {
    final today = DateTime.now().weekday - 1; // 0 = Monday, 6 = Sunday
    return _habits.where((habit) => habit.daysOfWeek.contains(today)).toList();
  }

  // Get completed habits today
  List<Habit> get completedToday {
    return todayHabits.where((habit) => habit.isCompletedToday()).toList();
  }

  // Get total completion rate
  double get completionRate {
    if (todayHabits.isEmpty) return 0.0;
    return completedToday.length / todayHabits.length;
  }

  // Get total streak across all habits
  int get totalStreak {
    return _habits.fold(0, (sum, habit) => sum + habit.streak);
  }

  // Get completions for a specific day of the week (0 = Monday, 6 = Sunday)
  int getCompletionsForDay(int dayIndex) {
    final today = DateTime.now();
    final targetDate = today.subtract(Duration(days: today.weekday - 1 - dayIndex));
    final dateString = targetDate.toIso8601String().split('T')[0];
    
    return _habits.where((habit) => 
      habit.daysOfWeek.contains(dayIndex) && 
      habit.completions.contains(dateString)
    ).length;
  }

  HabitProvider() {
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final habitsJson = prefs.getStringList('habits') ?? [];
      
      _habits = habitsJson
          .map((json) => Habit.fromJson(jsonDecode(json)))
          .toList();
      
      // Add demo data if no habits exist
      if (_habits.isEmpty) {
        _addDemoHabits();
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading habits: $e');
      _addDemoHabits();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveHabits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final habitsJson = _habits
          .map((habit) => jsonEncode(habit.toJson()))
          .toList();
      await prefs.setStringList('habits', habitsJson);
    } catch (e) {
      print('Error saving habits: $e');
    }
  }

  void addHabit(Habit habit) {
    _habits.add(habit);
    _saveHabits();
    notifyListeners();
  }

  void removeHabit(String id) {
    _habits.removeWhere((habit) => habit.id == id);
    _saveHabits();
    notifyListeners();
  }

  void toggleHabitCompletion(String id) {
    final habitIndex = _habits.indexWhere((habit) => habit.id == id);
    if (habitIndex != -1) {
      _habits[habitIndex].toggleCompletion();
      _saveHabits();
      notifyListeners();
    }
  }

  void _addDemoHabits() {
    _habits = [
      Habit(
        title: 'Morning Exercise',
        description: 'Start the day with energy',
        icon: '🏃‍♂️',
        daysOfWeek: [0, 1, 2, 3, 4], // Monday to Friday
      ),
      Habit(
        title: 'Read 30 Minutes',
        description: 'Expand your knowledge',
        icon: '📚',
        daysOfWeek: [0, 1, 2, 3, 4, 5, 6], // Daily
      ),
      Habit(
        title: 'Drink Water',
        description: 'Stay hydrated throughout the day',
        icon: '💧',
        daysOfWeek: [0, 1, 2, 3, 4, 5, 6], // Daily
      ),
      Habit(
        title: 'Meditation',
        description: 'Find inner peace and clarity',
        icon: '🧘‍♀️',
        daysOfWeek: [0, 2, 4, 6], // Mon, Wed, Fri, Sun
      ),
      Habit(
        title: 'Healthy Eating',
        description: 'Nourish your body with good food',
        icon: '🥗',
        daysOfWeek: [0, 1, 2, 3, 4, 5, 6], // Daily
      ),
      Habit(
        title: 'Early Sleep',
        description: 'Get quality rest for better health',
        icon: '😴',
        daysOfWeek: [0, 1, 2, 3, 4, 5, 6], // Daily
      ),
    ];
    
    // Add some completion history for demo
    final now = DateTime.now();
    for (int i = 0; i < _habits.length; i++) {
      final habit = _habits[i];
      // Add completions for the last 7 days
      for (int j = 0; j < 7; j++) {
        final date = now.subtract(Duration(days: j));
        if (habit.daysOfWeek.contains(date.weekday - 1)) {
          if (i < 3 || (i >= 3 && j % 2 == 0)) { // Some habits completed more than others
            habit.completions.add(date.toIso8601String().split('T')[0]);
          }
        }
      }
    }
    
    _saveHabits();
  }

  int getTotalStreak() {
    return _habits.fold(0, (sum, habit) => sum + habit.streak);
  }

  int getLongestStreak() {
    if (_habits.isEmpty) return 0;
    return _habits.map((habit) => habit.streak).reduce((a, b) => a > b ? a : b);
  }

  int getTotalCompletions() {
    return _habits.fold(0, (sum, habit) => sum + habit.totalCompletions);
  }
} 