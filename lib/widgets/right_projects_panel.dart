import 'package:flutter/material.dart';

import '../models/project.dart';
import '../theme/app_theme.dart';
import 'project_card.dart';

/// Right two-thirds of the screen: the "Recent Projects" title and a
/// vertically scrollable list of project cards.
class RightProjectsPanel extends StatelessWidget {
  const RightProjectsPanel({
    super.key,
    required this.projects,
    required this.isLoading,
    required this.onRefresh,
    required this.onOpen,
    required this.onDelete,
  });

  final List<Project> projects;
  final bool isLoading;
  final VoidCallback onRefresh;
  final ValueChanged<Project> onOpen;
  final ValueChanged<Project> onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('RECENT PROJECTS', style: AppTheme.eyebrow()),
              const Spacer(),
              IconButton(
                onPressed: isLoading ? null : onRefresh,
                icon: const Icon(Icons.refresh, size: 18),
                tooltip: 'Refresh',
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 6, bottom: 16),
            height: 2,
            width: 36,
            color: AppColors.brass,
          ),
          Expanded(child: _Body(isLoading: isLoading, projects: projects, onOpen: onOpen, onDelete: onDelete)),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.isLoading,
    required this.projects,
    required this.onOpen,
    required this.onDelete,
  });

  final bool isLoading;
  final List<Project> projects;
  final ValueChanged<Project> onOpen;
  final ValueChanged<Project> onDelete;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.brass),
      );
    }

if (projects.isEmpty) {
  return const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.inventory_2_outlined, color: AppColors.textMuted, size: 32),
        SizedBox(height: 12),
        Text(
          'No projects yet',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        SizedBox(height: 4),
        Text(
          'Start Editing to create your first one.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 12.5),
        ),
      ],
    ),
  );
}

    return ListView.separated(
      itemCount: projects.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final project = projects[index];
        return ProjectCard(
          project: project,
          onOpen: () => onOpen(project),
          onDelete: () => onDelete(project),
        );
      },
    );
  }
}
