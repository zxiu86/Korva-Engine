import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Thin full-width strip along the bottom of the screen showing the
/// default save directory and a stability indicator — the "telemetry
/// strip" that closes out the instrument-panel motif carried through the
/// rest of the layout.
class BottomStatusBar extends StatelessWidget {
  const BottomStatusBar({
    super.key,
    required this.path,
    required this.isReady,
  });

  /// The default save directory to display.
  final String path;

  /// Whether the save directory resolved successfully. This reflects the
  /// directory itself being usable, not the broad storage permission —
  /// Korva Engine still has a working (app-scoped) save location even
  /// before that permission is granted.
  final bool isReady;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.brass, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(
            isReady ? Icons.verified_user_outlined : Icons.warning_amber_rounded,
            size: 14,
            color: isReady ? AppColors.signalGreen : AppColors.signalRed,
          ),
          const SizedBox(width: 8),
          Text('SAVE DIRECTORY', style: AppTheme.eyebrow(color: AppColors.textMuted)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              path.isEmpty ? 'Resolving…' : path,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.mono(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isReady ? AppColors.signalGreen : AppColors.signalRed,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isReady ? 'STABLE' : 'CHECKING',
            style: AppTheme.eyebrow(
              color: isReady ? AppColors.signalGreen : AppColors.signalRed,
            ),
          ),
        ],
      ),
    );
  }
}
