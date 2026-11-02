import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deadline_buddy/models/task.dart';
import 'package:deadline_buddy/theme/app_theme.dart';
import 'package:deadline_buddy/widgets/task_card.dart';

Task testTask({
  required String dueDate,
  bool isCompleted = false,
}) {
  return Task(
    id: 1,
    title: 'Complete project report',
    description: 'Finish the final report',
    subject: 'Computer Science',
    dueDate: dueDate,
    isCompleted: isCompleted,
    createdAt: '2026-11-01T10:00:00.000',
    updatedAt: '2026-11-01T10:00:00.000',
  );
}

void main() {
  test('Task map round trip preserves fields', () {
    final task = testTask(dueDate: '2026-11-03');
    final restored = Task.fromMap({
      ...task.toMap(),
      'id': 1,
    });

    expect(restored.title, task.title);
    expect(restored.description, task.description);
    expect(restored.subject, task.subject);
    expect(restored.dueDate, task.dueDate);
    expect(restored.isCompleted, task.isCompleted);
  });

  test('Due labels distinguish today, overdue, and completed', () {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayText =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayText =
        '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';

    expect(dueLabel(testTask(dueDate: todayText)), 'Due today');
    expect(dueLabel(testTask(dueDate: yesterdayText)), 'Overdue');
    expect(
      dueLabel(testTask(dueDate: yesterdayText, isCompleted: true)),
      'Completed',
    );
  });

  testWidgets('Task card fits a narrow mobile layout without overflow',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: TaskCard(
              task: testTask(dueDate: '2026-11-03'),
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
