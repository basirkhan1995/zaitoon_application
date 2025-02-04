import 'dart:io';
import 'package:path/path.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:zaitoon_invoice/DatabaseHelper/components.dart';
import 'package:zaitoon_invoice/DatabaseHelper/default.dart';
import 'package:zaitoon_invoice/DatabaseHelper/tables.dart';
import 'package:zaitoon_invoice/DatabaseHelper/triggers.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _db;

  // Private constructor
  DatabaseHelper._privateConstructor();

  // Open the database (or create it if it doesn't exist)
  static Future<void> initDatabase(
      {required String dbName, required String path}) async {
    final dbPath = Directory(join(path, "Zaitoon"));

    //Create a directory 'Invoices' inside the destination
    if (!await dbPath.exists()) {
      await dbPath.create(
          recursive: true); // Create the custom folder if it doesn't exist
    }
    //'Zaitoon System' Directory
    final dbDestination = join(dbPath.path, dbName);

    if (_db != null) {
      close();
    }
    _db = sqlite3.open(dbDestination);

    //Actions
    initTables(); // Create Tables
    feedDatabase(); // Default Values
    triggers(); // Trigger

    await DatabaseComponents.saveDatabasePath(dbDestination);
  }

  // Open the database (or create it if it doesn't exist)
  static Future<void> browseDatabase(
      {required String dbName, required String path}) async {
    final dbPath = join(path, dbName);

    if (_db != null) {
      close();
    }
    _db = sqlite3.open(dbPath);
    await DatabaseComponents.saveDatabasePath(dbPath);
  }

  // Open the database (or create it if it doesn't exist)
  static Future<void> backupOpener({required String path}) async {
    if (_db != null) {
      close();
    }
    _db = sqlite3.open(path);
    await DatabaseComponents.saveDatabasePath(path);
  }

  // Only open Database method
  static Future<void> openDB(String completePath) async {
    // Close any previously opened database connection
    if (_db != null) {
      close();
    }
    _db = sqlite3.open(completePath);
  }

  static Future<void> initTables() async {
    if (_db != null) {
      // Enable foreign key constraints
      db.execute('PRAGMA foreign_keys = ON;');

      _db!.execute(Tables.metaDataTable);
      _db!.execute(Tables.userTable);

      //Accounts
      _db!.execute(Tables.accountCategoryTable);
      _db!.execute(Tables.accountsTable);

      // Roles & Permission
      _db!.execute(Tables.permissionsTable);
      _db!.execute(Tables.userRoleTable);
      _db!.execute(Tables.rolesPermissionsTable);

      //Currency
      _db!.execute(Tables.currencyTable);
    }
  }

  static Future<void> feedDatabase() async {
    if (_db != null) {
      _db!.execute(DefaultValues.defaultAccountCategory);
      _db!.execute(DefaultValues.defaultRoles);
    }
  }

  static Future<void> triggers() async {
    if (_db != null) {
      //_db!.execute(Triggers.invoiceNumberTrigger);
      _db!.execute(Triggers.accountNumberTrigger);
    }
  }

  static Database get db => _db!;

  // Close the database connection
  static void close() {
    if (_db != null) {
      _db!.dispose();
      _db = null;
    }
  }
}
