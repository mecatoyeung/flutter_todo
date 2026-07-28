import 'package:sembast_web/sembast_web.dart';

Future<Database> openTodoDatabase() =>
    databaseFactoryWeb.openDatabase('todo_flutter.db');
