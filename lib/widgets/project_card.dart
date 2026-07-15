import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/project.dart';
import '../theme/app_theme.dart';

/// A single row in the "Recent Projects" list: name, last-modified date,
/// a monospaced path preview, and a quick delete action.
class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
    required this.onOpen,
    required this.onDelete,
  });

  final Project project;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('MMM d, yyyy · h:mm a').format(project.lastModified);

    return Card(
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.steelSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.hairline),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.widgets_outlined, color: AppColors.brass, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      project.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(dateLabel, style: AppTheme.mono(fontSize: 11.5)),
                    const SizedBox(height: 2),
                    Text(
                      project.pathPreview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.mono(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 20),
                color: AppColors.textMuted,
                tooltip: 'Delete project',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
