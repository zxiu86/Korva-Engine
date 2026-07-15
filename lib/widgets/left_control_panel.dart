import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'korva_logo.dart';

/// Left third of the screen: the Korva Engine lockup up top, and the two
/// primary actions bottom-anchored like a title block on a technical
/// drawing.
class LeftControlPanel extends StatelessWidget {
  const LeftControlPanel({
    super.key,
    required this.onStartEditing,
    required this.onOpenProject,
    this.isBusy = false,
  });

  final VoidCallback onStartEditing;
  final VoidCallback onOpenProject;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(28, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const KorvaLogo(),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isBusy ? null : onStartEditing,
              icon: const Icon(Icons.add_circle_outline, size: 20),
              label: const Text('Start Editing'),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: isBusy ? null : onOpenProject,
              icon: const Icon(Icons.folder_open_outlined, size: 20),
              label: const Text('Open Project'),
            ),
          ),
        ],
      ),
    );
  }
}
