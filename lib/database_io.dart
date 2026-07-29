import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

import 'models.dart';

class TodoDatabase {
  TodoDatabase._(this._database);

  final Database _database;
  final _lists = stringMapStoreFactory.store('lists');
  final _todos = stringMapStoreFactory.store('todos');

  static Future<TodoDatabase> open() async {
    final directory = await getApplicationDocumentsDirectory();
    final database = await databaseFactoryIo.openDatabase(
      p.join(directory.path, 'todo_flutter.db'),
    );
    return TodoDatabase._(database);
  }

  Future<List<TodoListModel>> getLists() async {
    final records = await _lists.find(
      _database,
      finder: Finder(sortOrders: [SortOrder('name')]),
    );
    return records
        .map((record) => TodoListModel.fromRecord(record.key, record.value))
        .toList();
  }

  Future<List<TodoItem>> getTodos(String listId) async {
    final records = await _todos.find(
      _database,
      finder: Finder(
        filter: Filter.equals('listId', listId),
        sortOrders: [SortOrder('isDone'), SortOrder('dueAt')],
      ),
    );
    return records
        .map((record) => TodoItem.fromRecord(record.key, record.value))
        .toList();
  }

  Future<void> saveList(TodoListModel list) {
    return _lists.record(list.id).put(_database, list.toJson());
  }

  Future<void> deleteList(String id) async {
    await _database.transaction((transaction) async {
      await _lists.record(id).delete(transaction);
      final todos = await _todos.find(
        transaction,
        finder: Finder(filter: Filter.equals('listId', id)),
      );
      for (final todo in todos) {
        await _todos.record(todo.key).delete(transaction);
      }
    });
  }

  Future<void> saveTodo(TodoItem todo) {
    return _todos.record(todo.id).put(_database, todo.toJson());
  }

  Future<void> deleteTodo(String id) {
    return _todos.record(id).delete(_database);
  }
}
