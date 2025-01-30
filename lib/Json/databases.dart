class Databases {
  final String name;
  final String path;
  final int size;
  final String backupDirectory;

  Databases(
      {required this.name,
      required this.path,
      required this.size,
      required this.backupDirectory});

  Map<String, dynamic> toJson() => {
        'name': name,
        'path': path,
        'size': size,
        'backupDirectory': backupDirectory,
      };

  factory Databases.fromJson(Map<String, dynamic> json) {
    return Databases(
        name: json['name'],
        path: json['path'],
        size: json['size'],
        backupDirectory: json['backupDirectory']);
  }
}
