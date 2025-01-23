import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import '../Json/database_info.dart';

class DatabaseComponents{

  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  static bool verifyPassword(String enteredPassword, String storedHashedPassword) {
    final enteredHashed = hashPassword(enteredPassword); // Hash the entered password
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
   static Future<List<DatabaseInfo>> loadRecentDatabase() async {
     final prefs = await SharedPreferences.getInstance();
     List<String> dbPaths = prefs.getStringList('recent_db_paths') ?? [];
     List<DatabaseInfo> dbInfoList = [];

     for (String path in dbPaths) {
       try {
         final file = File(path);
         if (await file.exists()) {
           String name = p.basenameWithoutExtension(path); // Extract file name
           int size = await file.length(); // Get file size in bytes
           String backupPath = p.dirname(path);
           String backup = join(backupPath,"$name Backup");
           dbInfoList.add(
               DatabaseInfo(
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

 }