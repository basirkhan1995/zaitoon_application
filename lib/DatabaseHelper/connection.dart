import 'dart:ffi';
import 'dart:io';
import 'package:sqlite3/sqlite3.dart';
import 'package:zaitoon_invoice/DatabaseHelper/tables.dart';

class DatabaseHelper {
  late final Database _db;

  // Initialize the SQLite3 Database
  Future<void> initDatabase() async {
    _db = sqlite3.open(initializeSQLiteLibrary() as String);
    _createTable();
  }

  // Load the correct SQLite3 library based on the platform
  DynamicLibrary initializeSQLiteLibrary() {
    if (Platform.isWindows) {
      return DynamicLibrary.open('sqlite3.dll');
    } else if (Platform.isMacOS) {
      return DynamicLibrary.open('libsqlite3.dylib');
    } else if (Platform.isLinux) {
      return DynamicLibrary.open('libsqlite3.so');
    } else {
      throw UnsupportedError('This platform is not supported.');
    }
  }

  // Create a table if it doesn't exist
  void _createTable() {
    _db.execute(Tables.userTable);
    _db.execute(Tables.itemUnitTable);
    _db.execute(Tables.accountsTable);
    _db.execute(Tables.accountTableName);
  }

  // Create (Insert) a user into the database
  void insertUser(String name, String email) {
    _db.execute('''
    INSERT INTO user (name, email)
    VALUES (?, ?);
    ''', [name, email]);
  }

  // Read (Query) all users from the database
  List<Map<String, Object?>> getUsers() {
    final result = _db.select('SELECT * FROM user');
    return result;
  }

  // Update a user in the database
  void updateUser(int id, String name, String email) {
    _db.execute('''
    UPDATE user
    SET name = ?, email = ?
    WHERE id = ?;
    ''', [name, email, id]);
  }

  // Delete a user by ID
  void deleteUser(int id) {
    _db.execute('DELETE FROM user WHERE id = ?;', [id]);
  }

  // Close the database connection
  void close() {
    _db.dispose();
  }
}
