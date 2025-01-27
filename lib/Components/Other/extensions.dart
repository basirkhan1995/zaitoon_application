import 'dart:math' as math;

extension GetFileNameExtension on String {
  String get getFileName {
    // Extract the file name from the path
    final fileName = split('/').last.split('\\').last;

    // Remove the extension if it exists
    final dotIndex = fileName.lastIndexOf('.');
    return dotIndex != -1 ? fileName.substring(0, dotIndex) : fileName;
  }
}

extension GetPathExtension on String {
  /// Extracts the directory path without the file name.
  String get getPathWithoutFileName {
    final segments = split(RegExp(r'[/\\]'));
    if (segments.length <= 1) return '';
    return segments.sublist(0, segments.length - 1).join('/');
  }
}

extension GetFirstLetterExtension on String {
  /// Returns a string containing the first letter of each word in uppercase.
  String get getFirstLetter {
    return split(RegExp(r'\s+')) // Split by spaces
        .where((word) => word.isNotEmpty) // Filter out empty strings
        .map((word) =>
            word[0].toUpperCase()) // Take the first letter and capitalize
        .join(); // Join the letters into a single string
  }
}

extension FormatDataExtension on int {
  String formatBytes(int bytes, [int decimals = 0]) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (math.log(bytes) / math.log(1024)).floor();
    return '${(bytes / math.pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}

extension RemoveWhiteSpaceExtension on String {
  String removeWhiteSpace(String text) {
    return text.replaceAll(RegExp(r'\s+'), '');
  }
}
