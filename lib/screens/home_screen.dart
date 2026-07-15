import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/project.dart';
import '../services/permission_service.dart';
import '../services/project_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_status_bar.dart';
import '../widgets/create_project_dialog.dart';
import '../widgets/left_control_panel.dart';
import '../widgets/right_projects_panel.dart';
import '../widgets/storage_permission_dialog.dart';
import 'editor_screen.dart';

/// The app's single top-level screen: left control rail, right recent
/// projects list, and a bottom status bar — see [LeftControlPanel],
/// [RightProjectsPanel], and [BottomStatusBar].
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Project> _projects = const [];
  String _defaultPath = '';
  bool _isLoadingProjects = true;
  bool _hasStorageAccess = false;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final path = await ProjectRepository.defaultProjectsPath();
    final status = await PermissionService.checkStatus();
    if (!mounted) return;
    setState(() {
      _defaultPath = path;
      _hasStorageAccess = status == StorageAccess.granted;
    });
    await _refreshProjects();
  }

  Future<void> _refreshProjects() async {
    setState(() => _isLoadingProjects = true);
    final projects = await ProjectRepository.listRecentProjects();
    if (!mounted) return;
    setState(() {
      _projects = projects;
      _isLoadingProjects = false;
    });
  }

  /// Shows the rationale dialog, then the system prompt, only when access
  /// isn't already granted. Returns true if the app can proceed.
  Future<bool> _ensureStorageAccess() async {
    if (_hasStorageAccess) return true;

    final agreed = await StoragePermissionDialog.show(context);
    if (!agreed || !mounted) return false;

    final result = await PermissionService.request();
    if (!mounted) return false;

    if (result == StorageAccess.granted) {
      setState(() => _hasStorageAccess = true);
      return true;
    }

    if (result == StorageAccess.permanentlyDenied) {
      _showSettingsPrompt();
    } else {
      _showSnack('Storage permission is needed to save to a custom folder.');
    }
    return false;
  }

  void _showSettingsPrompt() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission needed'),
        content: const Text(
          'Storage access was denied. You can enable "All files access" for '
          'Korva Engine from system settings at any time.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Not Now'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              PermissionService.openSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleStartEditing() async {
    final canProceed = await _ensureStorageAccess();
    if (!canProceed || !mounted) return;

    final result = await CreateProjectDialog.show(context, initialPath: _defaultPath);
    if (result == null || !mounted) return;

    await _refreshProjects();
    if (!mounted) return;
    _openEditor(result.project);
  }

  Future<void> _handleOpenProject() async {
    final canProceed = await _ensureStorageAccess();
    if (!canProceed || !mounted) return;

    setState(() => _isBusy = true);
    final selectedPath = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Open a Korva Engine project folder',
    );
    if (!mounted) return;
    setState(() => _isBusy = false);

    if (selectedPath == null) return;

    final project = await ProjectRepository.loadProjectFrom(selectedPath);
    if (!mounted) return;

    if (project == null) {
      _showSnack('No Korva Engine project was found in that folder.');
      return;
    }

    _openEditor(project);
  }

  void _openEditor(Project project) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => EditorScreen(project: project)),
    );
  }

  Future<void> _confirmDelete(Project project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete project?'),
        content: Text(
          '"${project.name}" and all of its files will be permanently deleted. '
          "This can't be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.signalRed),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await ProjectRepository.deleteProject(project);
    await _refreshProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child: LeftControlPanel(
                      isBusy: _isBusy,
                      onStartEditing: _handleStartEditing,
                      onOpenProject: _handleOpenProject,
                    ),
                  ),
                  const VerticalDivider(width: 1, thickness: 1, color: AppColors.hairline),
                  Expanded(
                    flex: 2,
                    child: RightProjectsPanel(
                      projects: _projects,
                      isLoading: _isLoadingProjects,
                      onRefresh: _refreshProjects,
                      onOpen: _openEditor,
                      onDelete: _confirmDelete,
                    ),
                  ),
                ],
              ),
            ),
            BottomStatusBar(path: _defaultPath, isReady: _defaultPath.isNotEmpty),
          ],
        ),
      ),
    );
  }
}
