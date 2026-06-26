import '../../../data/models/task_model.dart';

abstract class ITaskService {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> addTask(TaskModel task);
  Future<int> updateTask(TaskModel task);
  Future<int> deleteTask(int id);
}
