import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../theme/app_colors.dart';

DateTime taskDate(Task task) => DateTime.parse(task.dueDate);

String dueLabel(Task task) {
  if (task.isCompleted) return 'Completed';
  final today = DateTime.now();
  final date = taskDate(task);
  final todayDate = DateTime(today.year, today.month, today.day);
  final dueDate = DateTime(date.year, date.month, date.day);
  if (dueDate.isBefore(todayDate)) return 'Overdue';
  if (dueDate == todayDate) return 'Due today';
  return 'Due ${DateFormat('MMM d').format(dueDate)}';
}

Color dueColor(Task task) {
  if (task.isCompleted) return AppColors.highlight;
  final today = DateTime.now();
  final date = taskDate(task);
  final todayDate = DateTime(today.year, today.month, today.day);
  final dueDate = DateTime(date.year, date.month, date.day);
  if (dueDate.isBefore(todayDate)) return AppColors.error;
  if (dueDate == todayDate) return AppColors.warning;
  if (dueDate.difference(todayDate).inDays <= 3) return AppColors.warning;
  return AppColors.secondaryText;
}

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskCard({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final labelColor = dueColor(task);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: task.isCompleted
                      ? AppColors.highlight.withValues(alpha: 0.18)
                      : AppColors.primary.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  task.isCompleted
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: task.isCompleted
                      ? AppColors.highlight
                      : AppColors.accent,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration:
                            task.isCompleted ? TextDecoration.lineThrough : null,
                        color: task.isCompleted
                            ? AppColors.secondaryText
                            : AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${task.subject}  •  ${DateFormat('MMM d, yyyy').format(taskDate(task))}',
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: labelColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  dueLabel(task),
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
