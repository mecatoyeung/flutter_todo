enum TodoDateMode { none, date, dateTime }

class TodoListModel {
  const TodoListModel({required this.id, required this.name});

  final String id;
  final String name;

  Map<String, dynamic> toJson() => {'name': name};

  Map<String, dynamic> toJsonWithId() => {'id': id, ...toJson()};

  factory TodoListModel.fromRecord(String id, Map<String, dynamic> data) =>
      TodoListModel(id: id, name: data['name'] as String? ?? 'Untitled list');

  factory TodoListModel.fromJson(Map<String, dynamic> data) => TodoListModel(
    id: data['id'] as String,
    name: data['name'] as String? ?? 'Untitled list',
  );
}

class TodoItem {
  const TodoItem({
    required this.id,
    required this.listId,
    required this.subject,
    required this.description,
    required this.dateMode,
    this.dueAt,
    this.isDone = false,
  });

  final String id;
  final String listId;
  final String subject;
  final String description;
  final TodoDateMode dateMode;
  final DateTime? dueAt;
  final bool isDone;

  TodoItem copyWith({bool? isDone}) => TodoItem(
    id: id,
    listId: listId,
    subject: subject,
    description: description,
    dateMode: dateMode,
    dueAt: dueAt,
    isDone: isDone ?? this.isDone,
  );

  Map<String, dynamic> toJson() => {
    'listId': listId,
    'subject': subject,
    'description': description,
    'dateMode': dateMode.name,
    'dueAt': dueAt?.toIso8601String(),
    'isDone': isDone,
  };

  Map<String, dynamic> toJsonWithId() => {'id': id, ...toJson()};

  factory TodoItem.fromRecord(String id, Map<String, dynamic> data) => TodoItem(
    id: id,
    listId: data['listId'] as String,
    subject: data['subject'] as String? ?? '',
    description: data['description'] as String? ?? '',
    dateMode: TodoDateMode.values.firstWhere(
      (mode) => mode.name == data['dateMode'],
      orElse: () => TodoDateMode.none,
    ),
    dueAt: data['dueAt'] == null
        ? null
        : DateTime.tryParse(data['dueAt'] as String),
    isDone: data['isDone'] as bool? ?? false,
  );

  factory TodoItem.fromJson(Map<String, dynamic> data) => TodoItem(
    id: data['id'] as String,
    listId: data['listId'] as String,
    subject: data['subject'] as String? ?? '',
    description: data['description'] as String? ?? '',
    dateMode: TodoDateMode.values.firstWhere(
      (mode) => mode.name == data['dateMode'],
      orElse: () => TodoDateMode.none,
    ),
    dueAt: data['dueAt'] == null
        ? null
        : DateTime.tryParse(data['dueAt'] as String),
    isDone: data['isDone'] as bool? ?? false,
  );
}
