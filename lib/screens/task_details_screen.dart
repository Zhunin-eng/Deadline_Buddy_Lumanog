import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import '../theme/app_colors.dart';
import '../widgets/task_card.dart';
import 'task_form_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final _repository = TaskRepository();
  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  Future<void> _toggleStatus() async {
    final now = DateTime.now().toIso8601String();
    _task = _task.copyWith(isCompleted: !_task.isCompleted, updatedAt: now);
    try {
      await _repository.updateTask(_task);
      if (mounted) setState(() {});
    } catch (_) {
      _task = _task.copyWith(isCompleted: !_task.isCompleted, updatedAt: now);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not update the task. Please try again.'),
        ),
      );
    }
  }

  Future<void> _edit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TaskFormScreen(task: _task)),
    );
    try {
      final tasks = await _repository.getTasks();
      Task? updated;
      for (final task in tasks) {
        if (task.id == _task.id) {
          updated = task;
          break;
        }
      }
      if (updated != null && mounted) {
        final refreshedTask = updated;
        setState(() => _task = refreshedTask);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not refresh the task. Please reopen it.'),
        ),
      );
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete task?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _repository.deleteTask(_task.id!);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not delete the task. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelColor = dueColor(_task);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            onPressed: _edit,
            tooltip: 'Edit task',
            icon: const Icon(Icons.edit_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _task.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: labelColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          dueLabel(_task),
                          style: TextStyle(
                            color: labelColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _DetailRow(
                    icon: Icons.school_rounded,
                    label: 'Subject',
                    value: _task.subject,
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    icon: Icons.calendar_month_rounded,
                    label: 'Due date',
                    value: DateFormat('MMMM d, yyyy').format(taskDate(_task)),
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    icon: Icons.assignment_outlined,
                    label: 'Status',
                    value: _task.isCompleted ? 'Completed' : 'Pending',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _task.description.trim().isEmpty
                        ? 'No description provided.'
                        : _task.description,
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: _toggleStatus,
            icon: Icon(_task.isCompleted
                ? Icons.undo_rounded
                : Icons.check_circle_rounded),
            label: Text(_task.isCompleted ? 'Mark as Pending' : 'Mark as Completed'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _delete,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              minimumSize: const Size(0, 52),
              side: BorderSide(color: AppColors.error.withValues(alpha: 0.7)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('Delete Task'),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.highlight),
        const SizedBox(width: 10),
        Text('$label: ', style: const TextStyle(color: AppColors.secondaryText)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
