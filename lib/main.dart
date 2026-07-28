import 'package:flutter/material.dart';

import 'database.dart';
import 'models.dart';

void main() => runApp(const TodoApp());

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeData _theme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    // shadcn/ui's neutral palette: black/white surfaces with neutral grays.
    final scheme = ColorScheme(
      brightness: brightness,
      primary: isDark ? const Color(0xfffafafa) : const Color(0xff171717),
      onPrimary: isDark ? const Color(0xff171717) : const Color(0xfffafafa),
      primaryContainer: isDark
          ? const Color(0xffe5e5e5)
          : const Color(0xff262626),
      onPrimaryContainer: isDark
          ? const Color(0xff171717)
          : const Color(0xfffafafa),
      secondary: isDark ? const Color(0xff262626) : const Color(0xfff5f5f5),
      onSecondary: isDark ? const Color(0xfffafafa) : const Color(0xff171717),
      secondaryContainer: isDark
          ? const Color(0xff404040)
          : const Color(0xffe5e5e5),
      onSecondaryContainer: isDark
          ? const Color(0xfffafafa)
          : const Color(0xff171717),
      tertiary: isDark ? const Color(0xff404040) : const Color(0xffe5e5e5),
      onTertiary: isDark ? const Color(0xfffafafa) : const Color(0xff171717),
      tertiaryContainer: isDark
          ? const Color(0xff525252)
          : const Color(0xffd4d4d4),
      onTertiaryContainer: isDark
          ? const Color(0xfffafafa)
          : const Color(0xff171717),
      error: isDark ? const Color(0xffd4d4d4) : const Color(0xff404040),
      onError: isDark ? const Color(0xff171717) : const Color(0xfffafafa),
      errorContainer: isDark
          ? const Color(0xff404040)
          : const Color(0xffe5e5e5),
      onErrorContainer: isDark ? const Color(0xfffafafa) : const Color(0xff171717),
      surface: isDark ? const Color(0xff171717) : Colors.white,
      onSurface: isDark ? const Color(0xfffafafa) : const Color(0xff171717),
        surfaceContainerHighest: isDark
          ? const Color(0xff262626)
          : const Color(0xfff5f5f5),
      onSurfaceVariant: isDark
          ? const Color(0xffa3a3a3)
          : const Color(0xff737373),
      outline: isDark ? const Color(0xff525252) : const Color(0xffa3a3a3),
      outlineVariant: isDark
          ? const Color(0xff404040)
          : const Color(0xffe5e5e5),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: isDark ? Colors.white : const Color(0xff171717),
      onInverseSurface: isDark ? const Color(0xff171717) : Colors.white,
      inversePrimary: isDark ? const Color(0xff171717) : const Color(0xfffafafa),
      surfaceTint: Colors.transparent,
    );
    final surface = scheme.surface;
    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark
          ? const Color(0xff171717)
          : Colors.white,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.zero),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      filledButtonTheme: const FilledButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
        ),
      ),
      outlinedButtonTheme: const OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
        ),
      ),
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
        ),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
        ),
      ),
      checkboxTheme: const CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      segmentedButtonTheme: const SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CY Complete',
      debugShowCheckedModeBanner: false,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      themeMode: _themeMode,
      home: TodoHomePage(
        isDarkMode: _themeMode == ThemeMode.dark,
        onToggleTheme: () => setState(
          () => _themeMode = _themeMode == ThemeMode.dark
              ? ThemeMode.light
              : ThemeMode.dark,
        ),
      ),
    );
  }
}

class TodoController extends ChangeNotifier {
  TodoController(this.database);
  final TodoDatabase database;
  List<TodoListModel> lists = [];
  List<TodoItem> todos = [];
  String? selectedListId;
  bool isLoading = true;
  String? error;

  TodoListModel? get selectedList {
    for (final list in lists) {
      if (list.id == selectedListId) return list;
    }
    return null;
  }

  int get completedCount => todos.where((todo) => todo.isDone).length;

  Future<void> load() async {
    try {
      lists = await database.getLists();
      if (lists.isEmpty) {
        final list = TodoListModel(id: _id(), name: 'Personal');
        await database.saveList(list);
        lists = [list];
      }
      selectedListId ??= lists.first.id;
      todos = await database.getTodos(selectedListId!);
    } catch (exception) {
      error = 'Could not open local storage: $exception';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectList(String id) async {
    selectedListId = id;
    todos = await database.getTodos(id);
    notifyListeners();
  }

  Future<void> addList(String name) async {
    final list = TodoListModel(id: _id(), name: name.trim());
    await database.saveList(list);
    lists = [...lists, list];
    await selectList(list.id);
  }

  Future<void> renameList(String name) async {
    final current = selectedList;
    if (current == null || name.trim().isEmpty) return;
    final updated = TodoListModel(id: current.id, name: name.trim());
    await database.saveList(updated);
    lists = lists
        .map((list) => list.id == updated.id ? updated : list)
        .toList();
    notifyListeners();
  }

  Future<void> removeSelectedList() async {
    if (selectedListId == null) return;
    final id = selectedListId!;
    await database.deleteList(id);
    lists = lists.where((list) => list.id != id).toList();
    selectedListId = lists.isEmpty ? null : lists.first.id;
    todos = selectedListId == null
        ? []
        : await database.getTodos(selectedListId!);
    notifyListeners();
  }

  Future<void> saveTodo(TodoItem todo) async {
    await database.saveTodo(todo);
    todos = [...todos.where((item) => item.id != todo.id), todo];
    _sortTodos();
    notifyListeners();
  }

  Future<void> toggleTodo(TodoItem todo) =>
      saveTodo(todo.copyWith(isDone: !todo.isDone));

  Future<void> removeTodo(TodoItem todo) async {
    await database.deleteTodo(todo.id);
    todos = todos.where((item) => item.id != todo.id).toList();
    notifyListeners();
  }

  void _sortTodos() {
    todos.sort((a, b) {
      if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
      if (a.dueAt == null && b.dueAt == null) return 0;
      if (a.dueAt == null) return 1;
      if (b.dueAt == null) return -1;
      return a.dueAt!.compareTo(b.dueAt!);
    });
  }

  String _id() => DateTime.now().microsecondsSinceEpoch.toString();
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  TodoController? controller;

  @override
  void initState() {
    super.initState();
    _open();
  }

  Future<void> _open() async {
    final database = await TodoDatabase.open();
    final value = TodoController(database);
    if (!mounted) return;
    setState(() => controller = value);
    await value.load();
  }

  @override
  Widget build(BuildContext context) {
    final current = controller;
    if (current == null || current.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (current.error != null) {
      return Scaffold(body: Center(child: Text(current.error!)));
    }
    return AnimatedBuilder(
      animation: current,
      builder: (context, _) => TodoShell(
        controller: current,
        isDarkMode: widget.isDarkMode,
        onToggleTheme: widget.onToggleTheme,
      ),
    );
  }
}

class TodoShell extends StatelessWidget {
  const TodoShell({
    super.key,
    required this.controller,
    required this.isDarkMode,
    required this.onToggleTheme,
  });
  final TodoController controller;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 760;
            if (wide) {
              return Row(
                children: [
                  TodoSidebar(
                    controller: controller,
                    isDarkMode: isDarkMode,
                    onToggleTheme: onToggleTheme,
                  ),
                  Expanded(
                    child: TodoContent(
                      controller: controller,
                      isDarkMode: isDarkMode,
                      onToggleTheme: onToggleTheme,
                    ),
                  ),
                ],
              );
            }
            return TodoContent(
              controller: controller,
              showMenu: true,
              isDarkMode: isDarkMode,
              onToggleTheme: onToggleTheme,
            );
          },
        ),
      ),
    );
  }
}

class TodoSidebar extends StatelessWidget {
  const TodoSidebar({
    super.key,
    required this.controller,
    required this.isDarkMode,
    required this.onToggleTheme,
  });
  final TodoController controller;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 254,
      padding: const EdgeInsets.fromLTRB(22, 28, 14, 18),
      color: const Color(0xff171717),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CY Complete',
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'A clear mind starts here.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: .72),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 42),
          Text(
            'YOUR LISTS',
            style: TextStyle(
              color: Colors.white.withValues(alpha: .65),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                for (final list in controller.lists)
                  ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    selected: list.id == controller.selectedListId,
                    selectedTileColor: Colors.white.withValues(alpha: .13),
                    leading: Icon(
                      Icons.list_alt,
                      size: 19,
                      color: Colors.white.withValues(alpha: .85),
                    ),
                    title: Text(
                      list.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    onTap: () => controller.selectList(list.id),
                  ),
              ],
            ),
          ),
          const Divider(color: Colors.white24),
          TextButton.icon(
            onPressed: onToggleTheme,
            icon: Icon(
              isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              size: 18,
            ),
            label: Text(isDarkMode ? 'Light mode' : 'Dark mode'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              alignment: Alignment.centerLeft,
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => showListDialog(context, controller),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New list'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withValues(alpha: .5)),
              minimumSize: const Size.fromHeight(42),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TodoContent extends StatelessWidget {
  const TodoContent({
    super.key,
    required this.controller,
    required this.isDarkMode,
    required this.onToggleTheme,
    this.showMenu = false,
  });
  final TodoController controller;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final bool showMenu;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final list = controller.selectedList;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            showMenu ? 20 : 42,
            28,
            showMenu ? 20 : 42,
            18,
          ),
          child: Row(
            children: [
              if (showMenu) ...[
                IconButton(
                  tooltip: 'Switch list',
                  onPressed: () => showListPicker(context, controller),
                  icon: Icon(Icons.list_alt, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 2),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list?.name ?? 'Your tasks',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${controller.todos.length} tasks · ${controller.completedCount} completed',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (list != null)
                IconButton(
                  tooltip: 'Rename list',
                  onPressed: () =>
                      showListDialog(context, controller, existing: list),
                  icon: const Icon(Icons.edit_outlined),
                ),
              if (list != null)
                IconButton(
                  tooltip: 'Delete list',
                  onPressed: () => confirmDeleteList(context, controller),
                  icon: const Icon(Icons.delete_outline),
                ),
              if (showMenu)
                IconButton(
                  tooltip: isDarkMode ? 'Use light theme' : 'Use dark theme',
                  onPressed: onToggleTheme,
                  icon: Icon(
                    isDarkMode
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: list == null
              ? EmptyState(
                  title: 'No lists yet',
                  message: 'Create a list to organize your tasks.',
                  actionLabel: 'Create a list',
                  onAdd: () => showListDialog(context, controller),
                )
              : controller.todos.isEmpty
              ? EmptyState(onAdd: () => showTodoDialog(context, controller))
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    showMenu ? 20 : 42,
                    8,
                    showMenu ? 20 : 42,
                    100,
                  ),
                  itemCount: controller.todos.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => TodoCard(
                    todo: controller.todos[index],
                    controller: controller,
                  ),
                ),
        ),
        if (list != null)
          Padding(
            padding: EdgeInsets.fromLTRB(
              showMenu ? 20 : 42,
              12,
              showMenu ? 20 : 42,
              20,
            ),
            child: FilledButton.icon(
              onPressed: () => showTodoDialog(context, controller),
              icon: const Icon(Icons.add),
              label: const Text('Add task'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.onAdd,
    this.title = 'Nothing on your plate',
    this.message = 'Add a task to get started.',
    this.actionLabel = 'Create first task',
  });
  final VoidCallback onAdd;
  final String title;
  final String message;
  final String actionLabel;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.done_all,
          size: 54,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: .35),
        ),
        const SizedBox(height: 14),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          message,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 18),
        OutlinedButton(onPressed: onAdd, child: Text(actionLabel)),
      ],
    ),
  );
}

class TodoCard extends StatelessWidget {
  const TodoCard({super.key, required this.todo, required this.controller});
  final TodoItem todo;
  final TodoController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overdue =
        todo.dueAt != null &&
        todo.dueAt!.isBefore(DateTime.now()) &&
        !todo.isDone;
    return Card(
      child: InkWell(
        onTap: () => showTodoDialog(context, controller, existing: todo),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: todo.isDone,
                onChanged: (_) => controller.toggleTodo(todo),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.subject,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        decoration: todo.isDone
                            ? TextDecoration.lineThrough
                            : null,
                        color: todo.isDone
                          ? theme.colorScheme.onSurfaceVariant
                          : null,
                      ),
                    ),
                    if (todo.description.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        todo.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                    ],
                    if (todo.dateMode != TodoDateMode.none) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 15,
                            color: overdue
                                ? theme.colorScheme.error
                                : theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            formatDue(todo),
                            style: TextStyle(
                              fontSize: 12,
                              color: overdue
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Delete task',
                onPressed: () => confirmDeleteTodo(context, controller, todo),
                icon: const Icon(Icons.close, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatDue(TodoItem todo) {
  final date = todo.dueAt;
  if (date == null) return 'No date';
  final day = '${date.day}'.padLeft(2, '0');
  final month = '${date.month}'.padLeft(2, '0');
  if (todo.dateMode == TodoDateMode.date) return '$day/$month/${date.year}';
  final hour = '${date.hour}'.padLeft(2, '0');
  final minute = '${date.minute}'.padLeft(2, '0');
  return '$day/$month/${date.year} · $hour:$minute';
}

Future<void> showListPicker(
  BuildContext context,
  TodoController controller,
) async {
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: SizedBox(
        height: 380,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 12, 12),
              child: Row(
                children: [
                  Text(
                    'Your lists',
                    style: Theme.of(sheetContext).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'New list',
                    onPressed: () async {
                      Navigator.pop(sheetContext);
                      await showListDialog(context, controller);
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                children: [
                  for (final list in controller.lists)
                    ListTile(
                      selected: list.id == controller.selectedListId,
                      leading: const Icon(Icons.list_alt),
                      title: Text(list.name),
                      trailing: list.id == controller.selectedListId
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () async {
                        await controller.selectList(list.id);
                        if (sheetContext.mounted) Navigator.pop(sheetContext);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> showListDialog(
  BuildContext context,
  TodoController controller, {
  TodoListModel? existing,
}) async {
  final field = TextEditingController(text: existing?.name ?? '');
  final name = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(existing == null ? 'New list' : 'Rename list'),
      content: TextField(
        controller: field,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'List name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, field.text),
          child: Text(existing == null ? 'Create' : 'Save'),
        ),
      ],
    ),
  );
  if (name == null || name.trim().isEmpty) return;
  if (existing == null) {
    await controller.addList(name);
  } else {
    await controller.renameList(name);
  }
}

Future<void> showTodoDialog(
  BuildContext context,
  TodoController controller, {
  TodoItem? existing,
}) async {
  final subject = TextEditingController(text: existing?.subject ?? '');
  final description = TextEditingController(text: existing?.description ?? '');
  var mode = existing?.dateMode ?? TodoDateMode.none;
  var dueAt = existing?.dueAt;
  final result = await showDialog<TodoItem>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) {
        Future<void> chooseDueDate() async {
          final picked = await showDatePicker(
            context: context,
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
            initialDate: dueAt ?? DateTime.now(),
          );
          if (picked == null) return;
          var next = picked;
          if (mode == TodoDateMode.dateTime) {
            if (!context.mounted) return;
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(dueAt ?? DateTime.now()),
            );
            if (time == null) return;
            next = DateTime(
              picked.year,
              picked.month,
              picked.day,
              time.hour,
              time.minute,
            );
          }
          setDialogState(() => dueAt = next);
        }

        return AlertDialog(
          title: Text(existing == null ? 'Add task' : 'Edit task'),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: subject,
                    autofocus: true,
                    decoration: const InputDecoration(labelText: 'Subject *'),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: description,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SegmentedButton<TodoDateMode>(
                    segments: const [
                      ButtonSegment(
                        value: TodoDateMode.none,
                        label: Text('No date'),
                      ),
                      ButtonSegment(
                        value: TodoDateMode.date,
                        label: Text('Date'),
                      ),
                      ButtonSegment(
                        value: TodoDateMode.dateTime,
                        label: Text('Date & time'),
                      ),
                    ],
                    selected: {mode},
                    onSelectionChanged: (value) => setDialogState(() {
                      mode = value.first;
                      if (mode == TodoDateMode.none) dueAt = null;
                    }),
                  ),
                  if (mode != TodoDateMode.none) ...[
                    const SizedBox(height: 14),
                    OutlinedButton.icon(
                      onPressed: chooseDueDate,
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: Text(
                        dueAt == null
                            ? 'Choose date'
                            : formatDue(
                                TodoItem(
                                  id: '',
                                  listId: '',
                                  subject: '',
                                  description: '',
                                  dateMode: mode,
                                  dueAt: dueAt,
                                ),
                              ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (subject.text.trim().isEmpty) return;
                Navigator.pop(
                  context,
                  TodoItem(
                    id:
                        existing?.id ??
                        DateTime.now().microsecondsSinceEpoch.toString(),
                    listId: controller.selectedListId!,
                    subject: subject.text.trim(),
                    description: description.text.trim(),
                    dateMode: mode,
                    dueAt: dueAt,
                    isDone: existing?.isDone ?? false,
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    ),
  );
  if (result != null) await controller.saveTodo(result);
}

Future<void> confirmDeleteTodo(
  BuildContext context,
  TodoController controller,
  TodoItem todo,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete task?'),
      content: Text('“${todo.subject}” will be removed.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (confirmed == true) await controller.removeTodo(todo);
}

Future<void> confirmDeleteList(
  BuildContext context,
  TodoController controller,
) async {
  final list = controller.selectedList;
  if (list == null) return;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete list?'),
      content: Text('Delete “${list.name}” and all its tasks?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (confirmed == true) await controller.removeSelectedList();
}
