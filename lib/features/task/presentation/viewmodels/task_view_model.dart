import 'package:flutter/material.dart';
import 'package:hackathon/core/database/database_helper.dart';
import 'package:hackathon/features/task/domain/entities/task.dart';

class TaskViewModel extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  
  int get totalTasksCount => _tasks.length;
  int get completedTasksCount => _tasks.where((t) => t.status == 1).length;
  int get pendingTasksCount => _tasks.where((t) => t.status == 0).length;

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();
    _tasks = await DatabaseHelper.instance.getAllTasks();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title, String description, String deadline) async {
    final task = Task(title: title, description: description, deadline: deadline);
    await DatabaseHelper.instance.insertTask(task);
    await loadTasks();
  }

  Future<void> toggleTaskStatus(Task task) async {
    final newStatus = task.status == 0 ? 1 : 0;
    if (task.id != null) {
      await DatabaseHelper.instance.updateTaskStatus(task.id!, newStatus);
      await loadTasks();
    }
  }

  Future<void> deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    await loadTasks();
  }
}
