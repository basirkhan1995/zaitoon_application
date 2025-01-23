import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:zaitoon_invoice/DatabaseHelper/tables.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static late final Database db;

  // Private constructor
  DatabaseHelper._privateConstructor();

  // Open the database (or create it if it doesn't exist)
  static Future<void> initDatabase(String dbName) async {
    final path = await getApplicationDocumentsDirectory();
    final dbPath = join(path.path, dbName);
    db = sqlite3.open(dbPath);
    createTables();
  }

  static void createTables() {
    Tables.userTable();
  }

  // // Insert a row
  // Future<void> insertRow(String name) async {
  //   final stmt = db.prepare('''
  //   INSERT INTO my_table (name) VALUES (?);
  //   ''');
  //   stmt.execute([name]);
  // }

  // // Query all rows
  // List<Map<String, dynamic>> queryAllRows() {
  //   final rows = db.select('SELECT * FROM my_table');
  //   return rows;
  // }

  // // Query a specific row by id
  // static Map<String, dynamic>? queryRow(int id) {
  //   final result = db.select('SELECT * FROM my_table WHERE id = ?', [id]);
  //   return result.isNotEmpty ? result.first : null;
  // }

  // Close the database
  void close() {
    db.dispose();
  }
}
