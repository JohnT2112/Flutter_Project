import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Future<Database>? _databaseFuture;

  Future<Database> get database {
    return _databaseFuture ??= _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'todo_app.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        isCompleted INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL
      )
    ''');
    await db.execute(
      'CREATE INDEX idx_tasks_isCompleted ON tasks(isCompleted)',
    );
    await db.execute(
      'CREATE INDEX idx_tasks_createdAt ON tasks(createdAt)',
    );
  }

  Future<void> _onUpgrade(
      Database db,
      int oldVersion,
      int newVersion,
      ) async {}

  Future<int> addTask(TaskModel task) async {
    final db = await database;
    return db.insert('tasks', task.toMap());
  }

  Future<List<TaskModel>> getAllTasks() => getTasks();

  Future<List<TaskModel>> getTasks({
    bool? isCompleted,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    final maps = await db.query(
      'tasks',
      where: isCompleted == null ? null : 'isCompleted = ?',
      whereArgs: isCompleted == null ? null : [isCompleted ? 1 : 0],
      orderBy: 'createdAt DESC, id DESC',
      limit: limit,
      offset: offset,
    );
    return maps.map(TaskModel.fromMap).toList();
  }

  Future<TaskModel?> getTaskById(int id) async {
    final db = await database;
    final maps = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return TaskModel.fromMap(maps.first);
  }

  Future<int> updateTask(TaskModel task) async {
    assert(task.id != null, 'Cannot update a task without an id');
    final db = await database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllTasks() async {
    final db = await database;
    return db.delete('tasks');
  }

  Future<void> close() async {
    final db = await _databaseFuture;
    await db?.close();
    _databaseFuture = null;
  }
}