import 'package:uuid/uuid.dart';

class Habit {
  final String id;
  final String title;
  final String? description;
  final String icon;
  final List<int> daysOfWeek; // 0 = Monday, 6 = Sunday
  final List<String> completions;
  int streak;

  Habit({
    String? id,
    required this.title,
    this.description,
    required this.icon,
    required this.daysOfWeek,
    List<String>? completions,
    int? streak,
  }) : 
    id = id ?? const Uuid().v4(),
    completions = completions ?? [],
    streak = streak ?? 0;

  bool isCompletedToday() {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return completions.contains(today);
  }

  void toggleCompletion() {
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    if (completions.contains(today)) {
      completions.remove(today);
      _updateStreak();
    } else {
      completions.add(today);
      _updateStreak();
    }
  }

  void _updateStreak() {
    final sortedCompletions = completions.toList()..sort();
    streak = 0;
    
    if (sortedCompletions.isEmpty) return;
    
    final today = DateTime.now().toIso8601String().split('T')[0];
    final todayIndex = sortedCompletions.indexOf(today);
    
    if (todayIndex == -1) {
      // Today is not completed, check consecutive days before today
      for (int i = sortedCompletions.length - 1; i >= 0; i--) {
        final completionDate = DateTime.parse(sortedCompletions[i]);
        final expectedDate = DateTime.now().subtract(Duration(days: sortedCompletions.length - 1 - i));
        
        if (completionDate.year == expectedDate.year &&
            completionDate.month == expectedDate.month &&
            completionDate.day == expectedDate.day) {
          streak++;
        } else {
          break;
        }
      }
    } else {
      // Today is completed, check consecutive days including today
      for (int i = todayIndex; i >= 0; i--) {
        final completionDate = DateTime.parse(sortedCompletions[i]);
        final expectedDate = DateTime.now().subtract(Duration(days: todayIndex - i));
        
        if (completionDate.year == expectedDate.year &&
            completionDate.month == expectedDate.month &&
            completionDate.day == expectedDate.day) {
          streak++;
        } else {
          break;
        }
      }
    }
  }

  int get totalCompletions => completions.length;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'daysOfWeek': daysOfWeek,
      'completions': completions,
      'streak': streak,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      daysOfWeek: List<int>.from(json['daysOfWeek']),
      completions: List<String>.from(json['completions']),
      streak: json['streak'],
    );
  }
} 