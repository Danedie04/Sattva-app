import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/habit.dart';
import '../data/default_habits.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Returns today's date string used as the Firestore document key
  static String get _todayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Reference to the current user's habits sub-collection for today
  static CollectionReference<Map<String, dynamic>>? _habitsRef(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('daily_habits')
        .doc(_todayKey)
        .collection('habits');
  }

  /// Seed today's habits if they don't exist yet
  static Future<void> seedTodayHabits() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = _habitsRef(user.uid);
    if (ref == null) return;

    // Check if already seeded today
    final snapshot = await ref.limit(1).get();
    if (snapshot.docs.isNotEmpty) return;

    // Write all default habits as individual documents
    final batch = _db.batch();
    for (final habit in getDefaultHabits()) {
      batch.set(ref.doc(habit.id), habit.toMap());
    }
    await batch.commit();
  }

  /// Stream today's habits in real-time
  static Stream<List<Habit>> streamTodayHabits() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    final ref = _habitsRef(user.uid);
    if (ref == null) return const Stream.empty();

    return ref.orderBy('name').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Habit.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  /// Toggle a single habit's completed state
  static Future<void> toggleHabit(Habit habit) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = _habitsRef(user.uid);
    if (ref == null) return;

    final newCompleted = !habit.completed;
    await ref.doc(habit.id).update({
      'completed': newCompleted,
      'completedAt': newCompleted ? DateTime.now().toIso8601String() : null,
    });
  }

  /// Reset all habits for today
  static Future<void> resetTodayHabits() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = _habitsRef(user.uid);
    if (ref == null) return;

    final snapshot = await ref.get();
    final batch = _db.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'completed': false, 'completedAt': null});
    }
    await batch.commit();
  }

  /// Save summary for streak/analytics tracking
  static Future<void> saveDailySummary({
    required int completed,
    required int total,
  }) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _db
        .collection('users')
        .doc(user.uid)
        .collection('summaries')
        .doc(_todayKey)
        .set({
      'date': _todayKey,
      'completed': completed,
      'total': total,
      'percent': total == 0 ? 0 : (completed / total * 100).round(),
      'savedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Fetch last 16 days of summaries for streak tracking
  static Future<List<Map<String, dynamic>>> fetchStreakData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await _db
        .collection('users')
        .doc(user.uid)
        .collection('summaries')
        .orderBy('date', descending: true)
        .limit(16)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
