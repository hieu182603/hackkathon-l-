import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('task_manager.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE tasks (
  id $idType,
  title $textType,
  description $textType,
  deadline $textType,
  status $integerType
  )
''');
  }

  Future<TaskModel> createTask(TaskModel task) async {
    final db = await instance.database;
    final id = await db.insert('tasks', task.toMap());
    return TaskModel(
      id: id,
      title: task.title,
      description: task.description,
      deadline: task.deadline,
      status: task.status,
    );
  }

  Future<List<TaskModel>> readAllTasks() async {
    final db = await instance.database;
    final orderBy = 'deadline ASC';
    final result = await db.query('tasks', orderBy: orderBy);

    return result.map((json) => TaskModel.fromMap(json)).toList();
  }

  Future<int> updateTask(TaskModel task) async {
    final db = await instance.database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
