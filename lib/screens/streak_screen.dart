import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../core/constants.dart';

class StreakScreen extends StatefulWidget {
  const StreakScreen({super.key});

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  List<Map<String, dynamic>> _data = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await FirestoreService.fetchStreakData();
    if (mounted) {
      setState(() {
        _data = data;
        _loading = false;
      });
    }
  }

  int get _currentStreak {
    int streak = 0;
    for (final day in _data) {
      final percent = day['percent'] as int? ?? 0;
      if (percent >= 80) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("16-DAY STREAK")),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.purpleAccent))
          : _data.isEmpty
              ? _emptyState()
              : _buildContent(),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart, color: Colors.white24, size: 64),
          SizedBox(height: 16),
          Text(
            "No data yet",
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            "Complete some habits today\nto start your streak!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white30, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Streak counter
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purpleAccent.withOpacity(0.3),
                  Colors.deepPurple.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              border: Border.all(color: Colors.purpleAccent.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Current Streak",
                        style: TextStyle(color: Colors.white54, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(
                      "$_currentStreak days 🔥",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Text("🏆", style: TextStyle(fontSize: 48)),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            "PAST 16 DAYS",
            style: TextStyle(
              color: Colors.white38,
              fontSize: 12,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),

          // Grid of day cards
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: _data.length,
              itemBuilder: (_, i) {
                final day = _data[i];
                final percent = day['percent'] as int? ?? 0;
                final date = day['date'] as String? ?? '';
                final dayNum = date.isNotEmpty ? date.split('-').last : '?';
                final color = percent >= 80
                    ? Colors.purpleAccent
                    : percent >= 50
                        ? Colors.purple.withOpacity(0.6)
                        : Colors.white12;

                return Container(
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.5)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayNum,
                        style: TextStyle(
                          color: percent >= 80
                              ? Colors.purpleAccent
                              : Colors.white38,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$percent%",
                        style: TextStyle(
                          color: percent >= 80
                              ? Colors.white70
                              : Colors.white30,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
