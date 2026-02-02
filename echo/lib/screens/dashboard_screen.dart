import 'package:flutter/material.dart';
import 'package:echo/config/theme.dart';
import 'package:echo/widgets/project_card.dart';
import 'package:echo/screens/add_project_screen.dart';
import 'package:echo/models/project_model.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  List<ProjectModel> _projects = [
    ProjectModel(
      id: '1',
      clientName: 'Acme Corp',
      projectTitle: 'Website Redesign',
      deadline: DateTime(2026, 2, 15),
      amount: 5000.0,
      isCompleted: false,
    ),
    ProjectModel(
      id: '2',
      clientName: 'Tech Solutions',
      projectTitle: 'Mobile App Development',
      deadline: DateTime(2026, 3, 1),
      amount: 8000.0,
      isCompleted: false,
    ),
    ProjectModel(
      id: '3',
      clientName: 'Design Studio',
      projectTitle: 'Logo Design',
      deadline: DateTime(2026, 1, 30),
      amount: 1500.0,
      isCompleted: false,
    ),
    ProjectModel(
      id: '4',
      clientName: 'E-Shop Inc',
      projectTitle: 'E-commerce Platform',
      deadline: DateTime(2026, 3, 20),
      amount: 12000.0,
      isCompleted: false,
    ),
    ProjectModel(
      id: '5',
      clientName: 'Marketing Agency',
      projectTitle: 'Social Media Campaign',
      deadline: DateTime(2026, 2, 10),
      amount: 3000.0,
      isCompleted: false,
    ),
  ];

  void _navigateToAddProject() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddProjectScreen(),
      ),
    );

    if (result != null && result is ProjectModel) {
      setState(() {
        _projects.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width > 600 ? 24.0 : 16.0;
    final iconSize = size.width > 600 ? 40.0 : 32.0;
    final titleFontSize = size.width > 600 ? 28.0 : 24.0;
    final bodyFontSize = size.width > 600 ? 16.0 : 14.0;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primaryBlue,
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontSize: size.width > 600 ? 24 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
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
                        textAlign: TextAlign.center,
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
                  ),
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
                      );
                    },
                  ),
          ),
        ],
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
