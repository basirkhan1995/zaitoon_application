import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import 'package:zaitoon_invoice/Json/backup_model.dart';
import 'package:zaitoon_invoice/Json/info.dart';
import '../Json/databases.dart';

class DatabaseComponents {
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  static bool verifyPassword(
      String enteredPassword, String storedHashedPassword) {
    final enteredHashed =
        hashPassword(enteredPassword); // Hash the entered password
    return enteredHashed == storedHashedPassword; // Compare the hashes
  }

  //Store Database
  static Future<void> saveDatabasePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the current list of recent paths, or initialize an empty list if none exists.
    List<String> recentPaths = prefs.getStringList('recent_db_paths') ?? [];

    // Add the new path to the front of the list if it's not already present.
    if (!recentPaths.contains(path)) {
      recentPaths.insert(0, path);
    }

    // Optional: limit the number of recent paths stored.
    if (recentPaths.length > 10) {
      recentPaths = recentPaths.sublist(0, 10); // Keep only the last 10 paths.
    }

    // Save the updated list back to SharedPreferences.
    await prefs.setStringList('recent_db_paths', recentPaths);
  }

  //Load Recent Databases
  static Future<List<Databases>> loadRecentDatabase() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> dbPaths = prefs.getStringList('recent_db_paths') ?? [];
    List<Databases> dbInfoList = [];

    for (String path in dbPaths) {
      try {
        final file = File(path);
        if (await file.exists()) {
          String name = p.basenameWithoutExtension(path); // Extract file name
          int size = await file.length(); // Get file size in bytes
          String backupPath = p.dirname(path);
          String backup = join(backupPath, "$name Backup");
          dbInfoList.add(Databases(
            name: name,
            path: path,
            size: size,
            backupDirectory: backup,
          ));
        } else {
          print('File not found: $path');
        }
      } catch (e) {
        print('Error processing file at $path: ${e.toString()}');
      }
    }

    // Optionally, update SharedPreferences to remove invalid paths
    List<String> validPaths = dbInfoList.map((db) => db.path).toList();
    await prefs.setStringList('recent_db_paths', validPaths);
    return dbInfoList;
  }

  /// Remove SharedPreferences Database
  static Future<void> removeDatabasePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> dbPaths = prefs.getStringList('recent_db_paths') ?? [];

    if (dbPaths.contains(path)) {
      dbPaths.remove(path);
      await prefs.setStringList('recent_db_paths', dbPaths);
    }
  }

  //Load Backup
  static Future<List<DatabaseBackupInfo>> loadRecentBackupDatabase() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> dbPaths = prefs.getStringList('recent_backup_paths') ?? [];
    List<DatabaseBackupInfo> dbInfoList = [];
    for (String path in dbPaths) {
      try {
        final file = File(path);
        if (await file.exists()) {
          String name = p.basenameWithoutExtension(path); // Extract file name
          int size = await file.length(); // Get file size in bytes
          final lastModified = await file.lastModified();
          final createdDate =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(lastModified);
          dbInfoList.add(DatabaseBackupInfo(
              name: name,
              path: path,
              size: size,
              dateTime: DateTime.parse(createdDate)));
        } else {
          print('File not found: $path');
        }
      } catch (e) {
        print('Error processing file at $path: ${e.toString()}');
      }
    }

    // Optionally, update SharedPreferences to remove invalid paths
    List<String> validPaths = dbInfoList.map((db) => db.path).toList();
    await prefs.setStringList('recent_backup_paths', validPaths);
    return dbInfoList;
  }

  static Future<bool> _isDatabaseExists(String databasePath) async {
    return File(databasePath).existsSync();
  }

  static Future<Directory> createBackupDirectory(
      String dbDir, String dbName) async {
    Directory backupDir = Directory(join(dbDir, '$dbName Backup'));
    if (!await backupDir.exists()) {
      try {
        await backupDir.create(recursive: true);
        print('Backup directory created at: ${backupDir.path}');
      } catch (e) {
        print('Error creating backup directory: $e');
      }
    }
    return backupDir;
  }

  // Helper method to generate a unique backup name
  static Future<String> _generateUniqueBackupName(
      String backupDirectoryPath, String databaseName) async {
    int counter = 1;

    // Construct the base name without the counter.
    String baseDatabaseName = databaseName;

    // We will continue to increment until we find a unique name that doesn't exist.
    while (
        await File(join(backupDirectoryPath, '$baseDatabaseName ($counter).db'))
            .exists()) {
      counter++; // Increment the counter each time.
    }
    // Return the final unique name.
    return '$baseDatabaseName ($counter).db';
  }

  static Future<void> createDatabaseBackup(
      {required String databasePath, required String databaseName}) async {
    try {
      // Create Backup Directory
      final backupDirectory =
          await createBackupDirectory(databasePath, databaseName);

      // Database File Path
      final dbFilePath = join(databasePath, '$databaseName.db');

      // Find a unique name for the backup file
      String uniqueDatabaseName = await _generateUniqueBackupName(
        backupDirectory.path,
        databaseName,
      );

      // Backup Destination
      final backupFilePath = join(backupDirectory.path, uniqueDatabaseName);

      // Check if the database file exists
      final dbFile = File(dbFilePath);
      if (await dbFile.exists()) {
        // Copy the database file to the backup location
        await dbFile.copy(backupFilePath);
      }
    } on PlatformException catch (e) {
      print("Error during backup: $e");
    }
  }

  //To store selected db from list, to access it later on
  static Future<void> saveSelectedDatabase(Databases dbInfo) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = dbInfo.toJson();
    await prefs.setString('selected_database', jsonEncode(jsonString));
  }

  //To get the stored db info
  static Future<Databases?> getSelectedDatabaseInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('selected_database');

    if (jsonString != null) {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return Databases.fromJson(json);
    }
    return null; // No database selected
  }

  static Future<List<DatabaseBackupInfo>> loadDatabaseBackupFiles(
      {required String path}) async {
    final directory = Directory(path);
    final dbFiles = directory.listSync(recursive: false).where((file) {
      final ext = p.extension(file.path);
      return ext == '.db' || ext == '.sqlite';
    });

    return dbFiles.map((file) {
      final fileName = p.basenameWithoutExtension(file.path);
      final fileSize = File(file.path).lengthSync(); // Get file size in bytes
      return DatabaseBackupInfo(
        name: fileName,
        path: file.path,
        size: fileSize,
        dateTime: DateTime.now(),
      );
    }).toList();
  }

  Future<DatabaseInfo> getDb({required String info}) async {
    return DatabaseInfo(name: info, path: info, size: 0, backupDirectory: info);
  }
}
