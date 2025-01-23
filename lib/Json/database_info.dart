
class DatabaseInfo {
  final String name;
  final String path;
  final int size;
  final String backupDirectory;

  DatabaseInfo({required this.name, required this.path, required this.size,required this.backupDirectory});

  Map<String, dynamic> toJson() => {
    'name': name,
    'path': path,
    'size':size,
    'backupDirectory': backupDirectory,
  };

  factory DatabaseInfo.fromJson(Map<String, dynamic> json) {
    return DatabaseInfo(
        name: json['name'],
        path: json['path'],
        size: json['size'],
        backupDirectory: json['backupDirectory']
    );
  }
}
