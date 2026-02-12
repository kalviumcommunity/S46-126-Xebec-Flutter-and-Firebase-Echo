import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/theme.dart';
import '../models/project_model.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final bool isDark;
  final VoidCallback? onTap;
  final ValueChanged<ProjectStatus>? onStatusChanged;
  final VoidCallback? onDelete;

  const ProjectCard({
    super.key,
    required this.project,
    required this.isDark,
    this.onTap,
    this.onStatusChanged,
    this.onDelete,
  });

  Color _statusColor(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.toDo:
        return AppTheme.neonPink;
      case ProjectStatus.inProgress:
        return AppTheme.neonPurple;
      case ProjectStatus.paid:
        return AppTheme.neonGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(project.status);

    return Hero(
      tag: 'project-${project.id}',
      child: Container(
        decoration: AppTheme.glassmorphism(
          color: isDark ? AppTheme.darkCard : Colors.white,
          opacity: isDark ? 0.07 : 0.92,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          project.projectTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: statusColor),
                        ),
                        child: Text(
                          project.status.label,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    project.clientName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.event,
                          size: 15,
                          color: isDark ? Colors.white70 : AppTheme.darkGrey),
                      const SizedBox(width: 6),
                      Text(DateFormat('MMM dd, yyyy').format(project.deadline)),
                      const Spacer(),
                      Text(
                        '\$${project.amount.toStringAsFixed(0)}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<ProjectStatus>(
                          initialValue: project.status,
                          items: ProjectStatus.values
                              .map(
                                (status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status.label),
                                ),
                              )
                              .toList(),
                          onChanged: onStatusChanged == null
                              ? null
                              : (value) {
                                  if (value != null) {
                                    onStatusChanged!(value);
                                  }
                                },
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.redAccent),
                        tooltip: 'Delete project',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
