import 'package:ToFinish/models/Task.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DBHelper {
  static Database _db;
  static const ID = 'id';
  static const DESCRIPTION = 'description';
  static const TIME = 'time';
  static const TIME_ELAPSED = 'time_elapsed';
  static const DATE_TIME = 'date_time';
  static const IS_COMPLETED = 'is_completed';
  static const TABLE = 'todo';
  static const DB_NAME = 'todo_list.db';

  Future<Database> get db async {
    if (_db != null){
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    print(path);
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return db;
  }

  _onCreate(Database db, int version) async {
    print("database version: " + version.toString());
    await db.execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $DESCRIPTION TEXT, $TIME INTEGER, $TIME_ELAPSED INTEGER, $DATE_TIME TEXT, $IS_COMPLETED INTEGER)");
  }

  _onUpgrade(Database db, int oldVersion, int newVersion){
    print('database upgrade....');
    print("database old version: " + oldVersion.toString());
    print("database new version: " + newVersion.toString());
    
  }

  Future<Task> addTodo (Task task) async {
    var dbClient = await db;
    task.id = await dbClient.insert(TABLE, task.toMap());
    return task;
  }

  Future<List<Task>> getTodos () async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, DESCRIPTION, TIME, TIME_ELAPSED, DATE_TIME, IS_COMPLETED]);
    List <Task> todos = [];
    if (maps.length > 0){
      for (int i = 0; i < maps.length; i++){
        todos.add(Task.fromMap(maps[i]));
      }
    }
    return todos;
  }

  Future<int> deleteTodo(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> updateTodo(Task task) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, task.toMap(), where: '$ID = ?', whereArgs: [task.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}






