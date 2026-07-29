import 'package:supabase_flutter/supabase_flutter.dart';

import 'models.dart';

const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

class TodoDatabase {
  TodoDatabase._(this._client);

  final SupabaseClient _client;

  static Future<TodoDatabase> open() async {
    if (_supabaseUrl.isEmpty || _supabaseAnonKey.isEmpty) {
      throw StateError(
        'Missing SUPABASE_URL or SUPABASE_ANON_KEY. '
        'Provide both via --dart-define when building/running Flutter Web.',
      );
    }
    return TodoDatabase._(SupabaseClient(_supabaseUrl, _supabaseAnonKey));
  }

  Future<List<TodoListModel>> getLists() async {
    final data = await _client.from(_listsTable).select('id, name');
    final rows = _asRows(data);
    return rows
        .map(
          (row) => TodoListModel.fromJson({
            'id': row['id'],
            'name': row['name'],
          }),
        )
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  Future<List<TodoItem>> getTodos(String listId) async {
    final data = await _client
        .from(_todosTable)
        .select('id, list_id, subject, description, date_mode, due_at, is_done')
        .eq('list_id', listId);
    final rows = _asRows(data);
    final todos = rows
        .map(
          (row) => TodoItem.fromJson({
            'id': row['id'],
            'listId': row['list_id'],
            'subject': row['subject'],
            'description': row['description'],
            'dateMode': row['date_mode'],
            'dueAt': row['due_at'],
            'isDone': row['is_done'],
          }),
        )
        .toList();
    todos.sort((a, b) {
      if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
      if (a.dueAt == null && b.dueAt == null) return 0;
      if (a.dueAt == null) return 1;
      if (b.dueAt == null) return -1;
      return a.dueAt!.compareTo(b.dueAt!);
    });
    return todos;
  }

  Future<void> saveList(TodoListModel list) async {
    await _client.from(_listsTable).upsert(
      {'id': list.id, 'name': list.name},
      onConflict: 'id',
    );
  }

  Future<void> deleteList(String id) async {
    await _client.from(_listsTable).delete().eq('id', id);
  }

  Future<void> saveTodo(TodoItem todo) async {
    await _client.from(_todosTable).upsert(
      {
        'id': todo.id,
        'list_id': todo.listId,
        'subject': todo.subject,
        'description': todo.description,
        'date_mode': todo.dateMode.name,
        'due_at': todo.dueAt?.toUtc().toIso8601String(),
        'is_done': todo.isDone,
      },
      onConflict: 'id',
    );
  }

  Future<void> deleteTodo(String id) async {
    await _client.from(_todosTable).delete().eq('id', id);
  }

  List<Map<String, dynamic>> _asRows(dynamic data) {
    if (data is! List) {
      throw StateError('Unexpected response shape from Supabase.');
    }
    return data.whereType<Map<String, dynamic>>().toList();
  }
}

const _listsTable = 'todo_lists';
const _todosTable = 'todo_items';
