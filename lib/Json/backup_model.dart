import 'dart:convert';

class DatabaseBackupInfo {
  final String name;
  final String path;
  final int size;
  final DateTime dateTime;

  DatabaseBackupInfo(
      {required this.name,
      required this.path,
      required this.size,
      required this.dateTime});

  Map<String, dynamic> toJson() => {
        'name': name,
        'path': path,
        'size': size,
        'dateTime': dateTime,
      };

  factory DatabaseBackupInfo.fromJson(Map<String, dynamic> json) {
    return DatabaseBackupInfo(
      name: json['name'],
      path: json['path'],
      size: json['size'],
      dateTime: json['dateTime'],
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
