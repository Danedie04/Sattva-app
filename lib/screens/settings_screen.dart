import 'package:flutter/material.dart';
import '../core/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SETTINGS")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionHeader("Preferences"),
          _settingsTile(
            icon: Icons.notifications_outlined,
            title: "Habit Reminders",
            subtitle: "Daily notifications for your habits",
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (v) => setState(() => _notificationsEnabled = v),
              activeThumbColor: AppConstants.primaryColor,
            ),
          ),
          _settingsTile(
            icon: Icons.dark_mode_outlined,
            title: "Dark Mode",
            subtitle: "Toggle dark / light theme",
            trailing: Switch(
              value: _darkMode,
              onChanged: (v) => setState(() => _darkMode = v),
              activeThumbColor: AppConstants.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          _sectionHeader("About"),
          _settingsTile(
            icon: Icons.info_outline,
            title: "Version",
            subtitle: "Sattva v1.0.0",
          ),
          _settingsTile(
            icon: Icons.favorite_outline,
            title: "Made with",
            subtitle: "Love & discipline 🙏",
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.purpleAccent,
          fontSize: 12,
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.purpleAccent),
        title: Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 15)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: Colors.white38, fontSize: 12)),
        trailing: trailing,
      ),
    );
  }
}
