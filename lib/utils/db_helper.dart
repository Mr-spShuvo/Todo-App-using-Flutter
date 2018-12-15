import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:minimal_todo/models/todo.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String todoTable = 'todo_table',
      colId = 'id',
      colTitle = 'title',
      colDescription = 'description',
      colPriority = 'priority',
      colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null)
      _databaseHelper = DatabaseHelper._createInstance();
    return _databaseHelper;
  }

  Future<Database> initializeDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'minimal_todo.db';
    var todoDb = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    return todoDb;
  }

  void _createDb(Database db, int version) async {
    var queries =
        'CREATE TABLE $todoTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colDescription TEXT, $colPriority INTEGER, $colDate TEXT)';
    await db.execute(queries);
  }

  Future<Database> get database async {
    if (_database == null) _database = await initializeDB();
    return _database;
  }

  /// Fetch Operation: Get all Todo Objects
  Future<List<Map<String, dynamic>>> getTodoMapList() async {
    Database db = await this.database;

    var result = await db.query(
      todoTable,
      orderBy: '$colPriority ASC',
    );
    return result;
  }

  /// Insert Operation: Insert a Todo Object to database
  Future<int> insertTodo(Todo todo) async {
    Database db = await this.database;
    var result = await db.insert(todoTable, todo.toMap());
    return result;
  }

  /// Delete Operation: delete a Todo Object to database
  Future<int> deleteTodo(int id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM $todoTable WHERE $colId = $id');
    return result;
  }

  /// Update Operation: delete a Todo Object to database
  Future<int> updateTodo(Todo todo) async {
    Database db = await this.database;
    var result = await db.update(
      todoTable,
      todo.toMap(),
      where: '$colId = ?',
      whereArgs: [todo.id],
    );
    return result;
  }

  /// Get the Number of Todo Objects
  Future<int> getCountTodo(Todo todo) async {
    Database db = await this.database;
    List<Map<String, dynamic>> value =
        await db.rawQuery('SELECT COUNT (*) from $todoTable');

    int result = Sqflite.firstIntValue(value);

    return result;
  }

  /// Convert TodoMapList to TodoList
  Future<List<Todo>> getTodoList() async {
    var todoMapList = await getTodoMapList();
    int count = todoMapList.length;
    List<Todo> todoList = List<Todo>();
    for (var i = 0; i < count; i++) {
      todoList.add(Todo.extracData(todoMapList[i]));
    }
    return todoList;
  }
}
