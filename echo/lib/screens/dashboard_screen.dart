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
    final user = _authService.currentUser;
    
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'User not authenticated',
            style: TextStyle(color: AppTheme.darkGrey),
          ),
        ),
      );
    }

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
      body: StreamBuilder<List<ProjectModel>>(
        stream: _firestoreService.getProjectsStream(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryBlue,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final projects = snapshot.data ?? [];
          final totalEarnings = projects.fold<double>(
            0,
            (sum, project) => sum + project.amount,
          );
          final pendingTasks = projects.where((p) => !p.isCompleted).length;

          return Column(
            children: [
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
                            '\$${totalEarnings.toStringAsFixed(0)}',
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
                    Container(
                      height: 60,
                      width: 1,
                      color: AppTheme.darkGrey.withOpacity(0.2),
                    ),
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
                            '$pendingTasks',
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
              Expanded(
                child: projects.isEmpty
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
