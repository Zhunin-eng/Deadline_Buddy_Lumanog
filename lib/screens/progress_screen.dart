import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import '../theme/app_colors.dart';
import '../widgets/summary_card.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final _repository = TaskRepository();
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = _repository.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: FutureBuilder<List<Task>>(
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
                      'Could not load progress data.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          final tasks = snapshot.data ?? [];
          final completed = tasks.where((task) => task.isCompleted).length;
          final pending = tasks.length - completed;
          final percentage =
              tasks.isEmpty ? 0 : ((completed / tasks.length) * 100).round();

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
            children: [
              Row(
                children: [
                  SummaryCard(
                    label: 'Total',
                    value: tasks.length,
                    icon: Icons.layers_rounded,
                  ),
                  const SizedBox(width: 10),
                  SummaryCard(
                    label: 'Pending',
                    value: pending,
                    icon: Icons.schedule_rounded,
                  ),
                  const SizedBox(width: 10),
                  SummaryCard(
                    label: 'Completed',
                    value: completed,
                    icon: Icons.check_circle_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 180,
                              height: 180,
                              child: CircularProgressIndicator(
                                value: percentage / 100,
                                strokeWidth: 14,
                                backgroundColor:
                                    AppColors.primary.withValues(alpha: 0.25),
                                color: AppColors.highlight,
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$percentage%',
                                  style: const TextStyle(
                                    fontSize: 38,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'completed',
                                  style: TextStyle(
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        tasks.isEmpty
                            ? 'Add tasks to start tracking your progress.'
                            : percentage == 100
                                ? 'Everything is complete. Great work!'
                                : '$pending task${pending == 1 ? '' : 's'} left to finish',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
