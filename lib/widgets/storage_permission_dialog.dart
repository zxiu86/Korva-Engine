import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Rationale dialog shown BEFORE the system storage-permission prompt,
/// explaining in plain terms why Korva Engine needs it. This satisfies
/// Android's "explain before you ask" guidance for sensitive permissions.
///
/// Returns `true` if the user chose to proceed to the system prompt,
/// `false` if they declined.
class StoragePermissionDialog extends StatelessWidget {
  const StoragePermissionDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const StoragePermissionDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 28, 28, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.steelSurface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.brass, width: 1.2),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.folder_special_outlined, color: AppColors.brass),
              ),
              const SizedBox(height: 18),
              const Text(
                'Access to project storage',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Korva Engine saves your projects as folders on your device '
                'so you can find, back up, or move them outside the app. To '
                'create and manage those folders wherever you choose, the '
                'app needs permission to manage files on this device.\n\n'
                'On the next screen, please enable "Allow access to manage '
                'all files" for Korva Engine.',
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Not Now'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
