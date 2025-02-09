import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import 'package:zaitoon_invoice/Json/backup_model.dart';
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
  static Future<List<AllDatabases>> loadRecentDatabase() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> dbPaths = prefs.getStringList('recent_db_paths') ?? [];
    List<AllDatabases> dbInfoList = [];

    for (String path in dbPaths) {
      try {
        final file = File(path);
        if (await file.exists()) {
          String name = p.basenameWithoutExtension(path); // Extract file name
          int size = await file.length(); // Get file size in bytes
          String backupPath = p.dirname(path);
          String backup = join(backupPath, "$name Backup");
          dbInfoList.add(AllDatabases(
            name: name,
            path: path,
            size: size,
            backupDirectory: backup,
          ));
        } else {
        }
      } catch (e) {
        throw e.toString();
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


  static Future<List<DatabaseBackupInfo>> loadDatabaseBackups({
    required String path,
  }) async {
    final directory = Directory(path);

    // Check if the directory exists
    if (!await directory.exists()) {
      return []; // Return an empty list if the directory does not exist
    }

    // List all files in the directory
    final files = await directory.list().toList();

    // Filter files with .db or .sqlite extensions
    final dbFiles = files.whereType<File>().where((file) {
      final ext = p.extension(file.path);
      return ext == '.db' || ext == '.sqlite';
    }).toList();

    // Load backup information for each file
    final backupInfos = await Future.wait(dbFiles.map((file) async {
      final fileStat = await FileStat.stat(file.path); // Get file metadata
      final fileSize = await file.length();
      return DatabaseBackupInfo(
        name: p.basename(file.path), // Use p.basename to get the file name
        path: file.path,
        size: fileSize,
        dateTime: fileStat.accessed, // Use the file's last modified date
      );
    }));

    // Sort the backups by dateTime in descending order (most recent first)
    backupInfos.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return backupInfos;
  }

  static Future<Directory> createBackupDirectory(
      String dbDir, String dbName) async {
    Directory backupDir = Directory(join(dbDir, '$dbName Backup'));
    if (!await backupDir.exists()) {
      try {
        await backupDir.create(recursive: true);
      } catch (e) {
        throw e.toString();
      }
    }
    return backupDir;
  }

  static Future<void> createDatabaseBackup({
    required String databasePath,
    required String databaseName,
  }) async {
    try {
      // Create Backup Directory
      final backupDirectory =
      await createBackupDirectory(databasePath, databaseName);

      // Database File Path
      final dbFilePath = p.join(databasePath, '$databaseName.db');

      // Find the next available backup counter globally
      final nextCounter = await _findNextBackupCounter(backupDirectory.path, databaseName);

      // Generate the backup filename
      final backupFileName = '$databaseName $nextCounter.db';
      final backupFilePath = p.join(backupDirectory.path, backupFileName);

      // Check if the database file exists
      final dbFile = File(dbFilePath);
      if (await dbFile.exists()) {
        // Copy the database file to the backup location
        await dbFile.copy(backupFilePath);
      } else {
      }
    } on PlatformException {
      throw "some error happened";
    }
  }

  /// Helper function to find the next available backup counter globally
  static Future<int> _findNextBackupCounter(String backupDirectoryPath, String databaseName) async {
    final backupDirectory = Directory(backupDirectoryPath);

    // Check if the backup directory exists
    if (!await backupDirectory.exists()) {
      return 1; // Start with 1 if no backups exist
    }

    // List all files in the backup directory
    final files = backupDirectory.listSync();

    // Filter files that match the backup naming pattern (e.g., "Zaitoon X.db")
    final backupFiles = files.whereType<File>().where((file) {
      final fileName = p.basename(file.path);
      return fileName.startsWith('$databaseName ') && fileName.endsWith('.db');
    }).toList();

    // Extract counters from the filenames
    final counters = backupFiles.map((file) {
      final fileName = p.basename(file.path);
      final counterString = fileName
          .substring(databaseName.length + 1, fileName.length - 3) // Remove "Zaitoon " and ".db"
          .trim();
      return int.tryParse(counterString) ?? 0; // Parse the counter or default to 0
    }).toList();

    // Find the highest counter and increment it
    if (counters.isEmpty) {
      return 1; // Start with 1 if no valid backups are found
    } else {
      return counters.reduce((a, b) => a > b ? a : b) + 1;
    }
  }

}
