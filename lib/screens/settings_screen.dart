import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.event_available_rounded,
                      size: 42,
                      color: AppColors.highlight,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Deadline Buddy',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Plan it. Track it. Finish it!',
                    style: TextStyle(color: AppColors.secondaryText),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Card(
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.offline_bolt_rounded,
                      color: AppColors.highlight),
                  title: Text('Offline storage'),
                  subtitle: Text('Your tasks are saved only on this device'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.palette_rounded,
                      color: AppColors.highlight),
                  title: Text('Theme'),
                  subtitle: Text('Dark green'),
                  trailing: Icon(Icons.check_circle_rounded,
                      color: AppColors.highlight),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Deadline Buddy',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Deadline Buddy is an offline student task manager for organizing assignments, projects, subjects, and deadlines.',
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      height: 1.45,
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
