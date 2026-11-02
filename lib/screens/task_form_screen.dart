import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import '../theme/app_colors.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repository = TaskRepository();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _subject;
  DateTime? _dueDate;
  bool _completed = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _title = TextEditingController(text: task?.title ?? '');
    _description = TextEditingController(text: task?.description ?? '');
    _subject = TextEditingController(text: task?.subject ?? '');
    _dueDate = task == null ? null : DateTime.parse(task.dueDate);
    _completed = task?.isCompleted ?? false;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _subject.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _dueDate == null) {
      if (_dueDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a due date')),
        );
      }
      return;
    }
    setState(() => _saving = true);
    final now = DateTime.now().toIso8601String();
    final date = DateFormat('yyyy-MM-dd').format(_dueDate!);
    final existing = widget.task;
    final task = Task(
      id: existing?.id,
      title: _title.text.trim(),
      description: _description.text.trim(),
      subject: _subject.text.trim(),
      dueDate: date,
      isCompleted: _completed,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
    try {
      if (existing == null) {
        await _repository.createTask(task);
      } else {
        await _repository.updateTask(task);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save the task. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.task != null;
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Edit Task' : 'Add Task')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _title,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Task title *',
                prefixIcon: Icon(Icons.title_rounded),
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Enter a task title' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _subject,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Subject *',
                prefixIcon: Icon(Icons.school_rounded),
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Enter a subject' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _description,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.notes_rounded),
              ),
            ),
            const SizedBox(height: 14),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(14),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Due date *',
                  prefixIcon: Icon(Icons.calendar_month_rounded),
                ),
                child: Text(
                  _dueDate == null
                      ? 'Select a date'
                      : DateFormat('MMMM d, yyyy').format(_dueDate!),
                  style: TextStyle(
                    color: _dueDate == null
                        ? AppColors.secondaryText
                        : AppColors.text,
                  ),
                ),
              ),
            ),
            if (editing) ...[
              const SizedBox(height: 14),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                tileColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                title: const Text('Completed'),
                value: _completed,
                activeThumbColor: AppColors.highlight,
                onChanged: (value) => setState(() => _completed = value),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save Task'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _saving ? null : () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.secondaryText,
                minimumSize: const Size(0, 52),
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
