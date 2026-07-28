import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

Future<Database> openTodoDatabase() async {
  final directory = await getApplicationDocumentsDirectory();
  return databaseFactoryIo.openDatabase(
    p.join(directory.path, 'todo_flutter.db'),
  );
}
