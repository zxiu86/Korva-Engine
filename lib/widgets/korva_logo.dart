import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Korva Engine's lockup: the bundled `assets/images/logo.png` mark, with
/// a matching wordmark. If the asset is ever missing, this falls back to
/// a programmatic monogram instead of a broken-image icon.
class KorvaLogo extends StatelessWidget {
  const KorvaLogo({super.key, this.markSize = 56});

  final double markSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(markSize * 0.22),
          child: Image.asset(
            'assets/images/logo.png',
            height: markSize,
            width: markSize,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _MonogramMark(size: markSize),
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'KORVA',
              style: TextStyle(
                fontSize: markSize * 0.32,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
                height: 1,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 5),
            Text('ENGINE', style: AppTheme.eyebrow(color: AppColors.brass)),
          ],
        ),
      ],
    );
  }
}

class _MonogramMark extends StatelessWidget {
  const _MonogramMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(size * 0.22),
        border: Border.all(color: AppColors.brass, width: 1.4),
      ),
      alignment: Alignment.center,
      child: Text(
        'K',
        style: TextStyle(
          fontSize: size * 0.52,
          fontWeight: FontWeight.w800,
          color: AppColors.brass,
          height: 1,
        ),
      ),
    );
  }
}
