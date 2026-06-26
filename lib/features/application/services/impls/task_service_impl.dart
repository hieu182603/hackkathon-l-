import '../../../data/local/database_helper.dart';
import '../../../data/models/task_model.dart';
import '../interfaces/i_task_service.dart';

class TaskServiceImpl implements ITaskService {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  Future<List<TaskModel>> getTasks() async {
    return await _databaseHelper.readAllTasks();
  }

  @override
  Future<TaskModel> addTask(TaskModel task) async {
    return await _databaseHelper.createTask(task);
  }

  @override
  Future<int> updateTask(TaskModel task) async {
    return await _databaseHelper.updateTask(task);
  }

  @override
  Future<int> deleteTask(int id) async {
    return await _databaseHelper.deleteTask(id);
  }
}
