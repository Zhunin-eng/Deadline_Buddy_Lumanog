import '../database/app_database.dart';
import '../models/task.dart';

class TaskRepository {
  Future<List<Task>> getTasks() async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query('tasks', orderBy: 'dueDate ASC, createdAt DESC');
    return maps.map(Task.fromMap).toList();
  }

  Future<int> createTask(Task task) async {
    final db = await AppDatabase.instance.database;
    return db.insert('tasks', task.toMap());
  }

  Future<int> updateTask(Task task) async {
    final db = await AppDatabase.instance.database;
    return db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(int id) async {
    final db = await AppDatabase.instance.database;
    return db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
