import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';

class ProgressCard extends StatelessWidget {
  final int completed;
  final int total;

  const ProgressCard({
    super.key,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = total == 0 ? 0 : completed / total;
    final int percent = (progress * 100).round();

    return Animate(
      effects: [FadeEffect(duration: 400.ms), ScaleEffect(begin: const Offset(0.96, 0.96), duration: 400.ms)],
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.border),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentGlow.withOpacity(0.10),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ring chart
            SizedBox(
              width: 80,
              height: 80,
              child: CustomPaint(
                painter: _RingPainter(progress: progress),
                child: Center(
                  child: Text(
                    "$percent%",
                    style: GoogleFonts.dmMono(
                      color: AppTheme.accent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Sattva",
                    style: GoogleFonts.cormorantGaramond(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "$completed",
                          style: GoogleFonts.cormorantGaramond(
                            color: AppTheme.textPrimary,
                            fontSize: 38,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: " / $total",
                          style: GoogleFonts.cormorantGaramond(
                            color: AppTheme.textMuted,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    percent == 100
                        ? "✦ Perfect day"
                        : percent >= 80
                            ? "Almost there"
                            : percent >= 50
                                ? "Keep going"
                                : "Start your routine",
                    style: TextStyle(
                      color: percent == 100
                          ? AppTheme.gold
                          : AppTheme.textSecondary,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const strokeWidth = 5.0;

    // Track
    canvas.drawCircle(
      center, radius,
      Paint()
        ..color = AppTheme.border
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Progress arc
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        Paint()
          ..shader = const LinearGradient(
            colors: [AppTheme.accent, AppTheme.accentGlow],
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}
