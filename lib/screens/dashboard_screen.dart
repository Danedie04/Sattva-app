import 'package:flutter/material.dart';
import '../data/default_habits.dart';
import '../widgets/habit_tile.dart';
import '../widgets/progress_card.dart';
import '../utils/quote_generator.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int get completed => defaultHabits.where((h) => h.completed).length;

  String _quote = QuoteGenerator.getQuote();

  void _resetAll() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161B2E),
        title: const Text("Reset All?", style: TextStyle(color: Colors.white)),
        content: const Text(
          "This will uncheck all habits for today.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                for (final h in defaultHabits) {
                  h.completed = false;
                }
              });
              Navigator.pop(ctx);
            },
            child: const Text("Reset",
                style: TextStyle(color: Colors.purpleAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SATTVA"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white54),
            tooltip: "Reset habits",
            onPressed: _resetAll,
          ),
        ],
      ),
      body: Column(
        children: [
          ProgressCard(
            completed: completed,
            total: defaultHabits.length,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const Text(
                  "Today's Habits",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                Text(
                  "$completed/${defaultHabits.length} done",
                  style: const TextStyle(
                    color: Colors.purpleAccent,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: defaultHabits.length,
              itemBuilder: (_, i) {
                return HabitTile(
                  habit: defaultHabits[i],
                  onChanged: () {
                    setState(() {
                      defaultHabits[i].completed = !defaultHabits[i].completed;
                    });
                  },
                );
              },
            ),
          ),

          GestureDetector(
            onTap: () => setState(() => _quote = QuoteGenerator.getQuote()),
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF161B2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purpleAccent.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.format_quote,
                      color: Colors.purpleAccent, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _quote,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
