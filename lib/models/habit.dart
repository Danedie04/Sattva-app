class Habit {
  String id;
  String name;
  String time;
  bool completed;
  String? emoji;
  DateTime? completedAt;

  Habit({
    required this.id,
    required this.name,
    required this.time,
    this.completed = false,
    this.emoji,
    this.completedAt,
  });

  /// Create from Firestore document data
  factory Habit.fromMap(String docId, Map<String, dynamic> map) {
    return Habit(
      id: docId,
      name: map['name'] as String? ?? '',
      time: map['time'] as String? ?? '',
      completed: map['completed'] as bool? ?? false,
      emoji: map['emoji'] as String?,
      completedAt: map['completedAt'] != null
          ? DateTime.tryParse(map['completedAt'] as String)
          : null,
    );
  }

  /// Convert to Firestore-safe map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'time': time,
      'completed': completed,
      'emoji': emoji,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  Habit copyWith({
    String? id,
    String? name,
    String? time,
    bool? completed,
    String? emoji,
    DateTime? completedAt,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      time: time ?? this.time,
      completed: completed ?? this.completed,
      emoji: emoji ?? this.emoji,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
