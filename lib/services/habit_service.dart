import '../models/habit.dart';
import '../data/default_habits.dart';

class HabitService {
  static List<Habit> habits = List.from(defaultHabits);

  static int get completedCount => habits.where((h) => h.completed).length;

  static double get progressPercent =>
      habits.isEmpty ? 0 : completedCount / habits.length;

  static void toggleHabit(int index) {
    habits[index].completed = !habits[index].completed;
  }

  static void resetAll() {
    for (final habit in habits) {
      habit.completed = false;
    }
  }
}
