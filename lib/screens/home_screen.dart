import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import '../theme/app_colors.dart';
import '../widgets/summary_card.dart';
import '../widgets/task_card.dart';
import 'task_details_screen.dart';
import 'tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  final Future<void> Function()? onAddTask;

  const HomeScreen({super.key, this.onAddTask});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repository = TaskRepository();
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = _repository.getTasks();
  }

  Future<void> _openTask(Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TaskDetailsScreen(task: task)),
    );
    if (mounted) setState(() => _tasksFuture = _repository.getTasks());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: _tasksFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline_rounded,
                      size: 48, color: AppColors.error),
                  SizedBox(height: 12),
                  Text(
                    'Could not load dashboard data.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        final tasks = snapshot.data ?? [];
        final pending = tasks.where((task) => !task.isCompleted).length;
        final completed = tasks.where((task) => task.isCompleted).length;
        final upcoming = tasks.where((task) {
          if (task.isCompleted) return false;
          final date = taskDate(task);
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          return !date.isBefore(today);
        }).take(5).toList();

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 100),
          children: [
            Text(
              'Hello, Student! 👋',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.text,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Stay on top of your deadlines',
              style: TextStyle(color: AppColors.secondaryText),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                SummaryCard(label: 'Total', value: tasks.length, icon: Icons.layers_rounded),
                const SizedBox(width: 10),
                SummaryCard(label: 'Pending', value: pending, icon: Icons.schedule_rounded),
                const SizedBox(width: 10),
                SummaryCard(label: 'Completed', value: completed, icon: Icons.check_circle_rounded),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upcoming deadlines',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TasksScreen()),
                    );
                  },
                  child: const Text('View all'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (snapshot.connectionState == ConnectionState.waiting)
              const Center(child: CircularProgressIndicator())
            else if (upcoming.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(Icons.event_available_rounded,
                          size: 42, color: AppColors.highlight),
                      SizedBox(height: 10),
                      Text('No upcoming deadlines'),
                      SizedBox(height: 4),
                      Text(
                        'Add a task to get started.',
                        style: TextStyle(
                            color: AppColors.secondaryText, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...upcoming.map((task) => TaskCard(task: task, onTap: () => _openTask(task))),
          ],
        );
      },
    );
  }
}
