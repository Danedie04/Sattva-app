import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/habit.dart';
import '../services/firestore_service.dart';

/// Central state manager for habits.
/// Listens to Firestore in real-time and exposes habits to the UI.
class HabitProvider extends ChangeNotifier {
  List<Habit> _habits = [];
  bool _loading = true;
  String? _error;
  StreamSubscription<List<Habit>>? _subscription;

  List<Habit> get habits => _habits;
  bool get loading => _loading;
  String? get error => _error;

  int get completedCount => _habits.where((h) => h.completed).length;
  int get totalCount => _habits.length;
  double get progressPercent =>
      totalCount == 0 ? 0 : completedCount / totalCount;

  /// Call once after user signs in to start listening to Firestore
  Future<void> init() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // Seed today's habits if first launch of the day
      await FirestoreService.seedTodayHabits();

      // Subscribe to real-time updates
      _subscription?.cancel();
      _subscription = FirestoreService.streamTodayHabits().listen(
        (habits) {
          _habits = habits;
          _loading = false;
          _error = null;
          notifyListeners();
        },
        onError: (Object e) {
          _error = 'Failed to load habits. Please check your connection.';
          _loading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _error = 'Initialization failed: $e';
      _loading = false;
      notifyListeners();
    }
  }

  /// Toggle a habit and auto-save summary
  Future<void> toggleHabit(Habit habit) async {
    // Optimistic UI update
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index == -1) return;
    _habits[index] = habit.copyWith(completed: !habit.completed);
    notifyListeners();

    // Persist to Firestore
    await FirestoreService.toggleHabit(habit);

    // Save daily summary for streak tracking
    await FirestoreService.saveDailySummary(
      completed: completedCount,
      total: totalCount,
    );
  }

  /// Reset all habits for today
  Future<void> resetAll() async {
    await FirestoreService.resetTodayHabits();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
