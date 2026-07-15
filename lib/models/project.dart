import 'dart:convert';

/// Represents a Korva Engine project stored on disk.
///
/// Each project is a folder containing a `.korvaproject` metadata file
/// (JSON) written by `ProjectRepository` when the project is created.
/// Reading that file back is how "Recent Projects" and "Open Project"
/// recognize a folder as a valid Korva Engine project.
class Project {
  const Project({
    required this.name,
    required this.directoryPath,
    required this.lastModified,
    this.engineVersion = '1.0.0',
  });

  final String name;
  final String directoryPath;
  final DateTime lastModified;
  final String engineVersion;

  static const metadataFileName = '.korvaproject';

  /// A shortened, display-friendly version of [directoryPath] for cards
  /// and the status bar, so long paths don't push other content around.
  String get pathPreview {
    const maxLength = 46;
    if (directoryPath.length <= maxLength) return directoryPath;
    final tail = directoryPath.substring(directoryPath.length - maxLength);
    return '…$tail';
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'engineVersion': engineVersion,
        'lastModified': lastModified.toIso8601String(),
      };

  factory Project.fromJson(Map<String, dynamic> json, String directoryPath) {
    return Project(
      name: json['name'] as String? ?? 'Untitled Project',
      directoryPath: directoryPath,
      engineVersion: json['engineVersion'] as String? ?? '1.0.0',
      lastModified:
          DateTime.tryParse(json['lastModified'] as String? ?? '') ?? DateTime.now(),
    );
  }

  String encodeMetadata() => const JsonEncoder.withIndent('  ').convert(toJson());
}
