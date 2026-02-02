import 'package:flutter/material.dart';
import 'package:echo/config/theme.dart';
import 'package:echo/widgets/project_card.dart';
import 'package:echo/screens/add_project_screen.dart';
import 'package:echo/models/project_model.dart';
import 'package:intl/intl.dart';
import 'package:echo/services/firestore_service.dart';
import 'package:echo/services/auth_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final _firestoreService = FirestoreService();
  final _authService = AuthService();

  void _navigateToAddProject() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddProjectScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(padding),
            padding: EdgeInsets.all(size.width > 600 ? 24 : 20),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primaryBlue.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        Icons.attach_money,
                        size: iconSize,
                        color: AppTheme.primaryBlue,
                      ),
                      SizedBox(height: padding / 2),
                      Text(
                        '\$15,000',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : AppTheme.darkGrey,
                        ),
                      ),
                      SizedBox(height: padding / 4),
                      Text(
                        'Total Earnings',
                        style: TextStyle(
                          fontSize: bodyFontSize,
                          color: isDarkMode 
                              ? Colors.white70 
                              : AppTheme.darkGrey.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                Container(
                  height: 60,
                  width: 1,
                  color: isDarkMode 
                      ? Colors.white24 
                      : AppTheme.darkGrey.withOpacity(0.2),
                ),
                
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        Icons.task_alt,
                        size: iconSize,
                        color: AppTheme.primaryBlue,
                      ),
                      SizedBox(height: padding / 2),
                      Text(
                        '8',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : AppTheme.darkGrey,
                        ),
                      ),
                      SizedBox(height: padding / 4),
                      Text(
                        'Pending Tasks',
                        style: TextStyle(
                          fontSize: bodyFontSize,
                          color: isDarkMode 
                              ? Colors.white70 
                              : AppTheme.darkGrey.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Projects',
                  style: TextStyle(
                    fontSize: size.width > 600 ? 22 : 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : AppTheme.darkGrey,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: AppTheme.primaryBlue,
                      fontSize: bodyFontSize,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Expanded(
            child: _projects.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.work_off_outlined,
                            size: size.width > 600 ? 140 : 120,
                            color: isDarkMode 
                                ? Colors.white24 
                                : AppTheme.darkGrey.withOpacity(0.3),
                          ),
                          SizedBox(height: padding * 1.5),
                          Text(
                            'No Projects Yet',
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : AppTheme.darkGrey,
                            ),
                          ),
                          SizedBox(height: padding / 2),
                          Text(
                            'Tap the + button to add your first project',
                            style: TextStyle(
                              fontSize: bodyFontSize,
                              color: isDarkMode 
                                  ? Colors.white60 
                                  : AppTheme.darkGrey.withOpacity(0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    itemCount: _projects.length,
                    itemBuilder: (context, index) {
                      final project = _projects[index];
                      final formattedDeadline = DateFormat('MMM dd, yyyy').format(project.deadline);
                      return Padding(
                        padding: EdgeInsets.only(bottom: padding * 0.75),
                        child: ProjectCard(
                          title: project.projectTitle,
                          deadline: formattedDeadline,
                          index: index,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          final project = projects[index];
                          final formattedDeadline = DateFormat('MMM dd, yyyy').format(project.deadline);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ProjectCard(
                              title: project.projectTitle,
                              deadline: formattedDeadline,
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProject,
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: AppTheme.darkGrey.withOpacity(0.5),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
