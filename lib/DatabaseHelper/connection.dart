import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:zaitoon_invoice/DatabaseHelper/tables.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._constructor();
  DatabaseHelper._constructor();
  static Database? _db;

  static Future<String> _getPath(String dbName) async {
    final databasePath = await getDownloadsDirectory();
    final path = join(databasePath!.path, dbName);
    return path;
  }

  // Initialize the SQLite3 Database
  static Future<void> initDatabase(String dbName) async {
    final databasePath = _getPath(dbName);
    _db = sqlite3.open(databasePath.toString());
    _createTable();
  }

  // Create a table if it doesn't exist
  static void _createTable() {
    _db?.execute(Tables.userTable);
    _db?.execute(Tables.itemUnitTable);
    _db?.execute(Tables.accountsTable);
    _db?.execute(Tables.accountTableName);
  }


  // Close the database connection
  void close() {
    _db?.dispose();
  }


}
