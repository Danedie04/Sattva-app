import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/habit.dart';
import '../core/theme.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final VoidCallback onChanged;
  final int index;

  const HabitTile({
    super.key,
    required this.habit,
    required this.onChanged,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final bool done = habit.completed;

    return Animate(
      effects: [
        FadeEffect(duration: 300.ms, delay: (index * 40).ms),
        SlideEffect(
          begin: const Offset(-0.04, 0),
          end: Offset.zero,
          duration: 300.ms,
          delay: (index * 40).ms,
        ),
      ],
      child: GestureDetector(
        onTap: onChanged,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: done
                ? AppTheme.accentGlow.withOpacity(0.10)
                : AppTheme.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: done
                  ? AppTheme.accent.withOpacity(0.35)
                  : AppTheme.border,
              width: 1,
            ),
            boxShadow: done
                ? [
                    BoxShadow(
                      color: AppTheme.accentGlow.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Row(
            children: [
              // Custom animated checkbox
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: done
                      ? AppTheme.accent
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: done ? AppTheme.accent : AppTheme.textMuted,
                    width: 1.5,
                  ),
                ),
                child: done
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
              const SizedBox(width: 14),

              // Emoji
              if (habit.emoji != null) ...[
                Text(habit.emoji!, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
              ],

              // Name + time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: done
                            ? AppTheme.textMuted
                            : AppTheme.textPrimary,
                        decoration: done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: AppTheme.textMuted,
                      ),
                      child: Text(habit.name),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      habit.time,
                      style: TextStyle(
                        fontSize: 11,
                        color: done
                            ? AppTheme.textMuted
                            : AppTheme.accent.withOpacity(0.7),
                        fontFamily: 'DM Mono',
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Right icon
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: done
                    ? Icon(Icons.verified_rounded,
                        key: const ValueKey('done'),
                        color: AppTheme.accent, size: 18)
                    : Icon(Icons.circle_outlined,
                        key: const ValueKey('todo'),
                        color: AppTheme.textMuted, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
