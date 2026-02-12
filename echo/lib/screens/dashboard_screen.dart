import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/project_model.dart';
import '../providers/auth_provider.dart';
import '../providers/client_provider.dart';
import '../providers/project_provider.dart';
import '../widgets/project_card.dart';
import 'add_project_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _tabIndex = 0;
  bool _showKanban = true;
  String? _listenedUserId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _openAddProject() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddProjectScreen()),
    );
  }

  Future<void> _openProjectDetail(ProjectModel project) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Hero(
          tag: 'project-${project.id}',
          child: Material(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.projectTitle,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Client: ${project.clientName}'),
                  Text(
                      'Deadline: ${DateFormat('MMM dd, yyyy').format(project.deadline)}'),
                  Text('Amount: \$${project.amount.toStringAsFixed(0)}'),
                  Text('Status: ${project.status.label}'),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openAddClientDialog() async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final companyController = TextEditingController();

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Client'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Required'
                            : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Phone'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: companyController,
                    decoration: const InputDecoration(labelText: 'Company'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop(true);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (shouldSave != true || !mounted) {
      return;
    }

    final userId = context.read<AuthProvider>().user?.uid;
    if (userId == null) {
      return;
    }

    await context.read<ClientProvider>().addClient(
          userId: userId,
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          company: companyController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final projectProvider = context.watch<ProjectProvider>();
    final clientProvider = context.watch<ClientProvider>();

    final userId = authProvider.user?.uid;
    if (userId == null) {
      return const Scaffold(
          body: Center(child: Text('Session expired. Please sign in again.')));
    }
    if (userId != _listenedUserId) {
      _listenedUserId = userId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        context.read<ProjectProvider>().listenToProjects(userId);
        context.read<ClientProvider>().listenToClients(userId);
      });
    }

    final pages = <Widget>[
      _OverviewTab(
        projectProvider: projectProvider,
        onOpenProject: _openProjectDetail,
        onDelete: (projectId) =>
            projectProvider.deleteProject(userId: userId, projectId: projectId),
        onUpdateStatus: (projectId, status) =>
            projectProvider.updateProjectStatus(
          userId: userId,
          projectId: projectId,
          status: status,
        ),
      ),
      _TaskTrackerTab(
        projectProvider: projectProvider,
        showKanban: _showKanban,
        onToggleView: () => setState(() => _showKanban = !_showKanban),
        onOpenProject: _openProjectDetail,
        onDelete: (projectId) =>
            projectProvider.deleteProject(userId: userId, projectId: projectId),
        onUpdateStatus: (projectId, status) =>
            projectProvider.updateProjectStatus(
          userId: userId,
          projectId: projectId,
          status: status,
        ),
      ),
      _ClientsTab(
        clientProvider: clientProvider,
        onAddClient: _openAddClientDialog,
        onDelete: (clientId) =>
            clientProvider.deleteClient(userId: userId, clientId: clientId),
      ),
      const ProfileScreen(),
    ];

    const titles = ['Dashboard', 'Task Tracker', 'Clients', 'Profile'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_tabIndex]),
        actions: [
          if (_tabIndex == 2)
            IconButton(
                onPressed: _openAddClientDialog,
                icon: const Icon(Icons.person_add_alt_1)),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: pages[_tabIndex],
      ),
      floatingActionButton: _tabIndex == 0 || _tabIndex == 1
          ? FloatingActionButton.extended(
              onPressed: _openAddProject,
              icon: const Icon(Icons.add),
              label: const Text('Project'),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (index) => setState(() => _tabIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.view_kanban_outlined), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.groups_2_outlined), label: 'Clients'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final ProjectProvider projectProvider;
  final Future<void> Function(ProjectModel) onOpenProject;
  final Future<bool> Function(String projectId) onDelete;
  final Future<bool> Function(String projectId, ProjectStatus status)
      onUpdateStatus;

  const _OverviewTab({
    required this.projectProvider,
    required this.onOpenProject,
    required this.onDelete,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cards = [
      _StatCard(
        title: 'Paid Earnings',
        value: '\$${projectProvider.completedEarnings.toStringAsFixed(0)}',
        icon: Icons.currency_rupee,
        gradient: const LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF00C853)]),
      ),
      _StatCard(
        title: 'Pending Tasks',
        value: '${projectProvider.pendingTasks}',
        icon: Icons.pending_actions,
        gradient: const LinearGradient(
            colors: [Color(0xFFFF6F00), Color(0xFFFF9800)]),
      ),
      _StatCard(
        title: 'Next 7 Days',
        value: '${projectProvider.upcomingDeadlines}',
        icon: Icons.event_available,
        gradient: const LinearGradient(
            colors: [Color(0xFF2962FF), Color(0xFF0091EA)]),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF080D1F),
                  Color(0xFF131A3F),
                  Color(0xFF0A122A)
                ],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFEAF2FF),
                  Color(0xFFF2F8FF),
                  Color(0xFFE6F4FF)
                ],
              ),
      ),
      child: Stack(
        children: [
          const _FuturisticBackground(),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Control Center',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
              ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.12),
              const SizedBox(height: 6),
              Text(
                'Real-time health of your freelance business',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
              ).animate().fadeIn(duration: 300.ms, delay: 120.ms),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: cards
                    .asMap()
                    .entries
                    .map(
                      (entry) => SizedBox(width: 220, child: entry.value)
                          .animate()
                          .fadeIn(
                              duration: 280.ms,
                              delay: (120 + entry.key * 120).ms)
                          .moveY(begin: 20, end: 0, duration: 320.ms),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              if (projectProvider.isLoading &&
                  projectProvider.allProjects.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 28),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (projectProvider.errorMessage != null &&
                  projectProvider.allProjects.isEmpty)
                _EmptyState(
                  icon: Icons.cloud_off,
                  title: 'Could not load projects',
                  subtitle: projectProvider.errorMessage!,
                )
              else ...[
                Text(
                  'Recent Projects',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (projectProvider.projects.isEmpty)
                  const _EmptyState(
                    icon: Icons.work_off_outlined,
                    title: 'No projects yet',
                    subtitle: 'Tap + Project to start tracking your work.',
                  ),
                ...projectProvider.projects
                    .take(6)
                    .toList()
                    .asMap()
                    .entries
                    .map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ProjectCard(
                          project: entry.value,
                          isDark: isDark,
                          onTap: () => onOpenProject(entry.value),
                          onDelete: () => onDelete(entry.value.id),
                          onStatusChanged: (status) =>
                              onUpdateStatus(entry.value.id, status),
                        )
                            .animate()
                            .fadeIn(
                              duration: 220.ms,
                              delay: (120 + entry.key * 70).ms,
                            )
                            .moveX(begin: 12, end: 0, duration: 240.ms),
                      ),
                    ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _TaskTrackerTab extends StatelessWidget {
  final ProjectProvider projectProvider;
  final bool showKanban;
  final VoidCallback onToggleView;
  final Future<void> Function(ProjectModel) onOpenProject;
  final Future<bool> Function(String projectId) onDelete;
  final Future<bool> Function(String projectId, ProjectStatus status)
      onUpdateStatus;

  const _TaskTrackerTab({
    required this.projectProvider,
    required this.showKanban,
    required this.onToggleView,
    required this.onOpenProject,
    required this.onDelete,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final projects = projectProvider.allProjects;

    if (projects.isEmpty) {
      return const _EmptyState(
        icon: Icons.view_kanban_outlined,
        title: 'Task tracker is empty',
        subtitle:
            'Add a project and move it between To-Do, In Progress, and Paid.',
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment<bool>(
                    value: true,
                    label: Text('Kanban'),
                    icon: Icon(Icons.view_kanban)),
                ButtonSegment<bool>(
                    value: false, label: Text('List'), icon: Icon(Icons.list)),
              ],
              selected: {showKanban},
              onSelectionChanged: (_) => onToggleView(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: showKanban
                ? ListView(
                    scrollDirection: Axis.horizontal,
                    children: ProjectStatus.values
                        .map(
                          (status) => _KanbanColumn(
                            title: status.label,
                            projects: projectProvider.byStatus(status),
                            isDark: isDark,
                            onOpenProject: onOpenProject,
                            onDelete: onDelete,
                            onUpdateStatus: onUpdateStatus,
                          ),
                        )
                        .toList(),
                  )
                : ListView(
                    children: projects
                        .map(
                          (project) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ProjectCard(
                              project: project,
                              isDark: isDark,
                              onTap: () => onOpenProject(project),
                              onDelete: () => onDelete(project.id),
                              onStatusChanged: (status) =>
                                  onUpdateStatus(project.id, status),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _KanbanColumn extends StatelessWidget {
  final String title;
  final List<ProjectModel> projects;
  final bool isDark;
  final Future<void> Function(ProjectModel) onOpenProject;
  final Future<bool> Function(String projectId) onDelete;
  final Future<bool> Function(String projectId, ProjectStatus status)
      onUpdateStatus;

  const _KanbanColumn({
    required this.title,
    required this.projects,
    required this.isDark,
    required this.onOpenProject,
    required this.onDelete,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title (${projects.length})',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: projects.isEmpty
                ? const Center(child: Text('No tasks'))
                : ListView(
                    children: projects
                        .map(
                          (project) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ProjectCard(
                              project: project,
                              isDark: isDark,
                              onTap: () => onOpenProject(project),
                              onDelete: () => onDelete(project.id),
                              onStatusChanged: (status) =>
                                  onUpdateStatus(project.id, status),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ClientsTab extends StatelessWidget {
  final ClientProvider clientProvider;
  final Future<void> Function() onAddClient;
  final Future<bool> Function(String clientId) onDelete;

  const _ClientsTab({
    required this.clientProvider,
    required this.onAddClient,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final clients = clientProvider.clients;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ElevatedButton.icon(
          onPressed: onAddClient,
          icon: const Icon(Icons.person_add_alt_1),
          label: const Text('Add Client'),
        ),
        const SizedBox(height: 12),
        if (clients.isEmpty)
          const _EmptyState(
            icon: Icons.groups_outlined,
            title: 'No clients yet',
            subtitle: 'Add client contacts to reuse while creating projects.',
          )
        else
          ...clients.map(
            (client) => Card(
              child: ListTile(
                leading: CircleAvatar(
                    child: Text(client.name.isEmpty
                        ? '?'
                        : client.name[0].toUpperCase())),
                title: Text(client.name),
                subtitle: Text([
                  if (client.company.isNotEmpty) client.company,
                  if (client.email.isNotEmpty) client.email,
                  if (client.phone.isNotEmpty) client.phone,
                ].join(' | ')),
                trailing: IconButton(
                  onPressed: () => onDelete(client.id),
                  icon:
                      const Icon(Icons.delete_outline, color: Colors.redAccent),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Gradient gradient;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Icon(icon, size: 52),
            const SizedBox(height: 10),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(subtitle, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _FuturisticBackground extends StatelessWidget {
  const _FuturisticBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -40,
            child: _GlowOrb(
              size: 220,
              color: const Color(0xFF00D9FF).withValues(alpha: 0.18),
              durationMs: 2800,
            ),
          ),
          Positioned(
            left: -60,
            top: 180,
            child: _GlowOrb(
              size: 180,
              color: const Color(0xFF9D4EDD).withValues(alpha: 0.18),
              durationMs: 3400,
            ),
          ),
          Positioned(
            right: 40,
            bottom: -40,
            child: _GlowOrb(
              size: 150,
              color: const Color(0xFF00F5A0).withValues(alpha: 0.14),
              durationMs: 2600,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;
  final int durationMs;

  const _GlowOrb({
    required this.size,
    required this.color,
    required this.durationMs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 80,
            spreadRadius: 18,
          ),
        ],
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true)).moveY(
          begin: -8,
          end: 10,
          duration: durationMs.ms,
          curve: Curves.easeInOut,
        );
  }
}
