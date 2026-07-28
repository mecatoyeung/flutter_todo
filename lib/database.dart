import 'package:sembast/sembast.dart';

import 'database_factory_io.dart'
    if (dart.library.html) 'database_factory_web.dart';
import 'models.dart';

class TodoDatabase {
  TodoDatabase._(this._database);

  final Database _database;
  final _lists = stringMapStoreFactory.store('lists');
  final _todos = stringMapStoreFactory.store('todos');

  static Future<TodoDatabase> open() async =>
      TodoDatabase._(await openTodoDatabase());

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

  Future<void> saveList(TodoListModel list) =>
      _lists.record(list.id).put(_database, list.toJson());

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

  Future<void> saveTodo(TodoItem todo) =>
      _todos.record(todo.id).put(_database, todo.toJson());

  Future<void> deleteTodo(String id) => _todos.record(id).delete(_database);
}
