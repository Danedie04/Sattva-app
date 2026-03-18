import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/habit_provider.dart';
import '../services/auth_service.dart';
import '../widgets/habit_tile.dart';
import '../widgets/progress_card.dart';
import '../utils/quote_generator.dart';
import 'progress_screen.dart';
import 'streak_screen.dart';
import 'settings_screen.dart';
import 'ai_coach_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _DashboardTab(),
    ProgressScreen(),
    AiCoachScreen(),
    StreakScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HabitProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border(top: BorderSide(color: AppTheme.border)),
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          indicatorColor: AppTheme.accentGlow.withOpacity(0.18),
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart_rounded),
              label: 'Progress',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined),
              selectedIcon: Icon(Icons.auto_awesome),
              label: 'Coach',
            ),
            NavigationDestination(
              icon: Icon(Icons.local_fire_department_outlined),
              selectedIcon: Icon(Icons.local_fire_department_rounded),
              label: 'Streak',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Premium Dashboard Tab
// ─────────────────────────────────────────────
class _DashboardTab extends StatefulWidget {
  const _DashboardTab();

  @override
  State<_DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<_DashboardTab> {
  String _quote = QuoteGenerator.getQuote();

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning";
    if (hour < 17) return "Good afternoon";
    return "Good evening";
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Reset Today?",
            style: GoogleFonts.cormorantGaramond(
                color: AppTheme.textPrimary, fontSize: 22)),
        content: Text(
          "This will uncheck all habits for today.",
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel",
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              context.read<HabitProvider>().resetAll();
              Navigator.pop(ctx);
            },
            child: Text("Reset",
                style: TextStyle(
                    color: AppTheme.accent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "SATTVA",
              style: GoogleFonts.cormorantGaramond(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded,
                color: AppTheme.textSecondary, size: 20),
            onPressed: () => _confirmReset(context),
          ),
          IconButton(
            icon: Icon(Icons.logout_rounded,
                color: AppTheme.textMuted, size: 20),
            onPressed: () => AuthService.signOut(),
          ),
        ],
      ),
      body: provider.loading
          ? Center(
              child: CircularProgressIndicator(
                  color: AppTheme.accent, strokeWidth: 2))
          : provider.error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(provider.error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.redAccent)),
                  ))
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Greeting
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                            child: Animate(
                              effects: [FadeEffect(duration: 400.ms)],
                              child: Text(
                                _greeting(),
                                style: GoogleFonts.cormorantGaramond(
                                  color: AppTheme.textSecondary,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),

                          ProgressCard(
                            completed: provider.completedCount,
                            total: provider.totalCount,
                          ),

                          // Section header
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                            child: Row(
                              children: [
                                Text(
                                  "TODAY'S ROUTINE",
                                  style: TextStyle(
                                    color: AppTheme.textMuted,
                                    fontSize: 11,
                                    letterSpacing: 1.5,
                                    fontFamily: 'DM Mono',
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "${provider.completedCount}/${provider.totalCount}",
                                  style: TextStyle(
                                    color: AppTheme.accent,
                                    fontSize: 11,
                                    fontFamily: 'DM Mono',
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Habit list
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => HabitTile(
                          habit: provider.habits[i],
                          index: i,
                          onChanged: () =>
                              provider.toggleHabit(provider.habits[i]),
                        ),
                        childCount: provider.habits.length,
                      ),
                    ),

                    // Quote footer
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                        child: GestureDetector(
                          onTap: () => setState(
                              () => _quote = QuoteGenerator.getQuote()),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppTheme.card,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("✦ ",
                                    style: TextStyle(
                                        color: AppTheme.gold, fontSize: 14)),
                                Expanded(
                                  child: Text(
                                    _quote,
                                    style: GoogleFonts.cormorantGaramond(
                                      fontStyle: FontStyle.italic,
                                      color: AppTheme.textSecondary,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
