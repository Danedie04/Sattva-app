import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../core/constants.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final completed = provider.completedCount;
    final total = provider.totalCount;

    return Scaffold(
      appBar: AppBar(title: const Text("PROGRESS")),
      body: provider.loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.purpleAccent))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppConstants.cardColor,
                      borderRadius:
                          BorderRadius.circular(AppConstants.borderRadius),
                      border: Border.all(
                          color: AppConstants.primaryColor.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Today's Score",
                          style:
                              TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "$completed / $total",
                          style: const TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${((completed / (total == 0 ? 1 : total)) * 100).round()}% Complete",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Habit Breakdown",
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          letterSpacing: 1),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: provider.habits.length,
                      separatorBuilder: (_, __) =>
                          const Divider(color: Colors.white10, height: 1),
                      itemBuilder: (_, i) {
                        final habit = provider.habits[i];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            habit.completed
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: habit.completed
                                ? Colors.purpleAccent
                                : Colors.white24,
                          ),
                          title: Text(
                            "${habit.emoji ?? ''} ${habit.name}".trim(),
                            style: TextStyle(
                              color: habit.completed
                                  ? Colors.white
                                  : Colors.white54,
                            ),
                          ),
                          trailing: Text(
                            habit.time,
                            style: const TextStyle(
                                color: Colors.white30, fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
