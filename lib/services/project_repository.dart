import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/project.dart';

/// Handles all on-disk project operations: resolving the default save
/// location, creating new project folders with Korva Engine's init
/// files, listing recent projects, loading a project from an arbitrary
/// folder, and deleting projects.
class ProjectRepository {
  ProjectRepository._();

  static const _rootFolderName = 'KorvaEngine';
  static const _projectsSubfolder = 'Projects';

  static String? _cachedDefaultPath;

  /// Resolves (and creates, if missing) the default projects directory.
  ///
  /// On Android this targets shared storage (e.g.
  /// `/storage/emulated/0/KorvaEngine/Projects`) so projects stay visible
  /// outside the app sandbox — browsable in a file manager, backed up,
  /// or moved between devices — which is why the app requests broad
  /// storage access rather than relying solely on app-private storage.
  /// If shared storage can't be resolved (permission not granted yet, or
  /// a non-Android platform), it falls back to the app's own documents
  /// directory so the app still works before the permission is granted.
  static Future<String> defaultProjectsPath() async {
    final cached = _cachedDefaultPath;
    if (cached != null) return cached;

    String base;
    try {
      if (Platform.isAndroid) {
        final root = await _androidSharedRoot();
        base = p.join(root, _rootFolderName, _projectsSubfolder);
      } else {
        final dir = await getApplicationDocumentsDirectory();
        base = p.join(dir.path, _rootFolderName, _projectsSubfolder);
      }
      await Directory(base).create(recursive: true);
    } catch (_) {
      final dir = await getApplicationDocumentsDirectory();
      base = p.join(dir.path, _rootFolderName, _projectsSubfolder);
      await Directory(base).create(recursive: true);
    }

    _cachedDefaultPath = base;
    return base;
  }

  /// Walks up from the app-specific external directory
  /// (`.../Android/data/<package>/files`) to the shared storage root
  /// (e.g. `/storage/emulated/0`) — the conventional way to locate
  /// shared storage on Android without extra native plugins.
  static Future<String> _androidSharedRoot() async {
    final extDir = await getExternalStorageDirectory();
    if (extDir == null) throw StateError('External storage unavailable');
    final marker = '${p.separator}Android${p.separator}';
    final index = extDir.path.indexOf(marker);
    if (index == -1) return extDir.path;
    return extDir.path.substring(0, index);
  }

  /// Scans [directoryPath] (defaults to the default projects path) one
  /// level deep for subfolders containing a [Project.metadataFileName]
  /// file, returning them sorted with the most recently modified first.
  static Future<List<Project>> listRecentProjects({String? directoryPath}) async {
    final basePath = directoryPath ?? await defaultProjectsPath();
    final baseDir = Directory(basePath);
    if (!await baseDir.exists()) return const [];

    final projects = <Project>[];
    await for (final entity in baseDir.list()) {
      if (entity is! Directory) continue;
      final metadataFile = File(p.join(entity.path, Project.metadataFileName));
      if (!await metadataFile.exists()) continue;

      try {
        final raw = await metadataFile.readAsString();
        final json = jsonDecode(raw) as Map<String, dynamic>;
        projects.add(Project.fromJson(json, entity.path));
      } catch (_) {
        // Skip unreadable/corrupt metadata rather than failing the whole list.
      }
    }

    projects.sort((a, b) => b.lastModified.compareTo(a.lastModified));
    return projects;
  }

  /// Creates a new project folder under [parentDirectoryPath] named
  /// [name], writes the Korva Engine metadata file, and scaffolds the
  /// minimal folder layout a fresh project starts with.
  static Future<Project> createProject({
    required String name,
    required String parentDirectoryPath,
  }) async {
    final projectDir = Directory(p.join(parentDirectoryPath, name));

    if (await projectDir.exists()) {
      throw StateError('A project named "$name" already exists at this location.');
    }

    await projectDir.create(recursive: true);
    await Directory(p.join(projectDir.path, 'assets')).create();
    await Directory(p.join(projectDir.path, 'scenes')).create();

    final project = Project(
      name: name,
      directoryPath: projectDir.path,
      lastModified: DateTime.now(),
    );

    final metadataFile = File(p.join(projectDir.path, Project.metadataFileName));
    await metadataFile.writeAsString(project.encodeMetadata());

    return project;
  }

  /// Loads a project from an arbitrary folder the user picked (e.g. via
  /// "Open Project"), rather than one inside the default directory.
  /// Returns null if the folder isn't a recognized Korva Engine project.
  static Future<Project?> loadProjectFrom(String directoryPath) async {
    final metadataFile = File(p.join(directoryPath, Project.metadataFileName));
    if (!await metadataFile.exists()) return null;

    try {
      final raw = await metadataFile.readAsString();
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return Project.fromJson(json, directoryPath);
    } catch (_) {
      return null;
    }
  }

  static Future<void> deleteProject(Project project) async {
    final dir = Directory(project.directoryPath);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }
}
