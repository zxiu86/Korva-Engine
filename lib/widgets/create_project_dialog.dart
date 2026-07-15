import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/project.dart';
import '../services/project_repository.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';

/// Result returned when the dialog successfully creates a project.
class CreateProjectResult {
  const CreateProjectResult(this.project);
  final Project project;
}

/// The "Start Editing" workflow: project name + path selection, with
/// validation, that creates the project's folder and metadata on disk.
class CreateProjectDialog extends StatefulWidget {
  const CreateProjectDialog({super.key, required this.initialPath});

  final String initialPath;

  static Future<CreateProjectResult?> show(
    BuildContext context, {
    required String initialPath,
  }) {
    return showDialog<CreateProjectResult>(
      context: context,
      builder: (context) => CreateProjectDialog(initialPath: initialPath),
    );
  }

  @override
  State<CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<CreateProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  late String _targetPath;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _targetPath = widget.initialPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickPath() async {
    final selected = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Choose a save location',
      initialDirectory: _targetPath,
    );
    if (selected != null && mounted) {
      setState(() => _targetPath = selected);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final project = await ProjectRepository.createProject(
        name: _nameController.text.trim(),
        parentDirectoryPath: _targetPath,
      );
      if (!mounted) return;
      Navigator.of(context).pop(CreateProjectResult(project));
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _errorMessage = error.toString().replaceFirst('StateError: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 26, 28, 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NEW PROJECT', style: AppTheme.eyebrow(color: AppColors.brass)),
                const SizedBox(height: 8),
                const Text(
                  'Start Editing',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 22),
                _FieldLabel('PROJECT NAME'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(hintText: 'e.g. Midnight Racer'),
                  validator: ProjectValidators.projectName,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 20),
                _FieldLabel('SAVE LOCATION'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.folder_outlined, size: 18, color: AppColors.steel),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _targetPath,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.mono(fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: _isSaving ? null : _pickPath,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Change Path'),
                      ),
                    ],
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 14),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: AppColors.signalRed, fontSize: 12.5),
                  ),
                ],
                const SizedBox(height: 26),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _submit,
                        child: _isSaving
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: AppColors.onBrass,
                                ),
                              )
                            : const Text('Create / Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: AppColors.textMuted,
      ),
    );
  }
}
