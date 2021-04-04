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
  static const TAG = 'tag';
  static const TIME = 'time';
  static const TIME_ELAPSED = 'time_elapsed';
  static const DATE_TIME = 'date_time';
  static const IS_COMPLETED = 'is_completed';
  static const TABLE_TODO = 'todo';
  static const TABLE_TAGS = 'tags';
  static const SUBTIMERS = 'subtimers';
  static const TAG_COUNT = 'tag_count';

  static const DB_NAME = 'timers.db';


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
    );
    return db;
  }

  _onCreate(Database db, int version) async {
    print("database version: " + version.toString());
    await db.execute(
      "CREATE TABLE $TABLE_TODO ($ID INTEGER PRIMARY KEY, $DESCRIPTION TEXT, $TAG TEXT, $TIME INTEGER, $TIME_ELAPSED INTEGER, $DATE_TIME TEXT, $IS_COMPLETED INTEGER, $SUBTIMERS INTEGER)"
    );
    await db.execute(
      "CREATE TABLE $TABLE_TAGS ($ID INTEGER PRIMARY KEY, $TAG TEXT, $TAG_COUNT INTEGER)"
    );
  }

  Future<Task> addTodo (Task task) async {
    var dbClient = await db;
    int id = await dbClient.insert(TABLE_TODO, task.toMap());
    task.id = id;
    return task;
  }

  Future<String> addTag(String tag) async{
    var dbClient = await db;
    String tagInsert = tag.trim().toLowerCase();
    if (tagInsert != ''){
      List<Map<String, dynamic>> result = await dbClient.query(TABLE_TAGS, columns: [ID, TAG, TAG_COUNT], where: '$TAG = ?', whereArgs: [tagInsert]);
      if (result.length == 0){
        Map<String, dynamic> newTag = {
          '$TAG': tagInsert,
          '$TAG_COUNT': 1,
        };
        await dbClient.insert(TABLE_TAGS, newTag);
        return tagInsert;
      } else {
        Map<String, dynamic> newMap = {
          '$TAG': tagInsert,
          '$TAG_COUNT': result[0]['$TAG_COUNT'] + 1
        };
        await dbClient.update(TABLE_TAGS, newMap, where: 'id = ?', whereArgs: [result[0]['id']]);
      }
    }
    return '';
  }

  Future<List<Task>> getTodos () async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(TABLE_TODO);
    return maps.length == 0 ? [] : maps.map((e) => Task.fromMap(e)).toList();
  }

  Future<List<Task>> getSubTimers(int id) async {
    var dbClient = await db;
    String table = 'SubTimersOf' + id.toString();
    List<Map<String, dynamic>> maps = await dbClient.query(table);
    return maps.map((e) => Task.fromMap(e)).toList();
  }

  Future<List<String>> getTags() async{
    var dbClient = await db;
    List<Map> tags = await dbClient.query(TABLE_TAGS, columns: [TAG]);
    List<String> res = [];
    for (Map tag in tags){
      res.add(tag['$TAG']);
    }
    return res;
  }

  Future deleteTodo(int id) async {
    print(id);
    var dbClient = await db;
    String tableName = 'SubTimersOf' + id.toString();
    await dbClient.delete(TABLE_TODO, where: "id = ?", whereArgs: [id]);
    await dbClient.execute(
      "DROP TABLE IF EXISTS $tableName"
    );
  }

  Future<String> deleteTag(String tag) async{
    var dbClient = await db;
    String tagDelete = tag.trim().toLowerCase();
    if (tagDelete != ''){
      print('delete tag: ' + tag);
      List<Map> tagRes = await dbClient.query(TABLE_TAGS, columns: [ID, TAG, TAG_COUNT], where: "$TAG = ?", whereArgs: [tagDelete]);
      print(tagRes);
      if (tagRes[0]['$TAG_COUNT'] == 1){
        await dbClient.delete(TABLE_TAGS, where: "$TAG = ?", whereArgs: [tagDelete]);
        return tagDelete;
      } else {
        Map<String, dynamic> newMap = {
          '$ID': tagRes[0]['$ID'],
          '$TAG': tagRes[0]['$TAG'],
          '$TAG_COUNT': tagRes[0]['$TAG_COUNT'] - 1
        };
        await dbClient.update(TABLE_TAGS, newMap, where: 'id = ?', whereArgs: [tagRes[0]['id']]);
      }
    }
    return '';
  }

  Future updateTodo(Task task) async {
    var dbClient = await db;
    await dbClient.update(TABLE_TODO, task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future updateSubtimer(int tableId, Task task) async{
    var dbClient = await db;
    String tableName = 'SubTimersOf' + tableId.toString();
    await dbClient.update(tableName, task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future updateTag(String oldTag, String newTag) async{
    deleteTag(oldTag);
    addTag(newTag);
  }

  Future<List<Task>> addSubTimers(String tableName, List<Task> subtasks) async{
    var dbClient = await db;
    tableName = 'SubTimersOf' + tableName;
    await dbClient.execute(
      "CREATE TABLE $tableName ($ID INTEGER PRIMARY KEY, $DESCRIPTION TEXT, $TAG TEXT, $TIME INTEGER, $TIME_ELAPSED INTEGER, $DATE_TIME TEXT, $IS_COMPLETED INTEGER, $SUBTIMERS INTEGER)"
    );
    for (Task subtask in subtasks){
      int id = await dbClient.insert(tableName, subtask.toMap());
      subtask.id = id;
    }
    return subtasks;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}






