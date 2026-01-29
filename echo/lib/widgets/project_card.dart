import 'package:flutter/material.dart';
import 'package:echo/config/theme.dart';

class ProjectCard extends StatelessWidget {
  final String title;
  final String deadline;

  const ProjectCard({
    super.key,
    required this.title,
    required this.deadline,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkGrey,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppTheme.darkGrey.withOpacity(0.6),
                ),
                const SizedBox(width: 8),
                Text(
                  'Deadline: $deadline',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.darkGrey.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
