import 'package:flutter/material.dart';
import 'package:echo/config/theme.dart';
import 'package:echo/screens/project_detail_screen.dart';

class ProjectCard extends StatelessWidget {
  final String title;
  final String deadline;
  final int? index;

  const ProjectCard({
    super.key,
    required this.title,
    required this.deadline,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final heroTag = 'project_$title${index ?? ''}';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Hero(
      tag: heroTag,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectDetailScreen(
                  title: title,
                  deadline: deadline,
                  heroTag: heroTag,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Card(
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
                      color: isDarkMode ? Colors.white : AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: isDarkMode 
                            ? Colors.white70 
                            : AppTheme.darkGrey.withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Deadline: $deadline',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode 
                              ? Colors.white70 
                              : AppTheme.darkGrey.withOpacity(0.7),
                        ),
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
