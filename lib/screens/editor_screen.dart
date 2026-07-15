import 'package:flutter/material.dart';

import '../models/project.dart';
import '../theme/app_theme.dart';

/// Placeholder editor screen. Korva Engine's actual editing workspace
/// would live here — this stub confirms the "Start Editing" / "Open
/// Project" transition and shows the loaded project's context.
class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.construction_outlined, color: AppColors.brass, size: 40),
              const SizedBox(height: 16),
              Text(
                project.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Editor workspace — coming soon',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13.5),
              ),
              const SizedBox(height: 4),
              Text(project.pathPreview, style: AppTheme.mono(fontSize: 11.5)),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Back to Projects'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
