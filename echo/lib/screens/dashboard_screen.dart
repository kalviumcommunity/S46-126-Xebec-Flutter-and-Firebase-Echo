import 'package:flutter/material.dart';
import 'package:echo/config/theme.dart';
import 'package:echo/widgets/project_card.dart';
import 'package:echo/screens/add_project_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  List<Map<String, String>> _projects = [
    {'title': 'Website Redesign', 'deadline': 'Feb 15, 2026'},
    {'title': 'Mobile App Development', 'deadline': 'Mar 1, 2026'},
    {'title': 'Logo Design', 'deadline': 'Jan 30, 2026'},
    {'title': 'E-commerce Platform', 'deadline': 'Mar 20, 2026'},
    {'title': 'Social Media Campaign', 'deadline': 'Feb 10, 2026'},
  ];

  void _navigateToAddProject() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddProjectScreen(),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _projects.add({
          'title': result['projectTitle'],
          'deadline': result['deadline'].toString(),
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primaryBlue,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // Summary Card at the top
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
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
                // Total Earnings
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        Icons.attach_money,
                        size: 32,
                        color: AppTheme.primaryBlue,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$15,000',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total Earnings',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.darkGrey.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                // Divider
                Container(
                  height: 60,
                  width: 1,
                  color: AppTheme.darkGrey.withOpacity(0.2),
                ),
                
                // Pending Tasks
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        Icons.task_alt,
                        size: 32,
                        color: AppTheme.primaryBlue,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '8',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pending Tasks',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.darkGrey.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Projects',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGrey,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // ListView of ProjectCard widgets or Empty State
          Expanded(
            child: _projects.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.work_off_outlined,
                          size: 120,
                          color: AppTheme.darkGrey.withOpacity(0.3),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No Projects Yet',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkGrey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the + button to add your first project',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.darkGrey.withOpacity(0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _projects.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ProjectCard(
                          title: _projects[index]['title']!,
                          deadline: _projects[index]['deadline']!,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProject,
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      
      // BottomNavigationBar UI
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
