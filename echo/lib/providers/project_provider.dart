import 'dart:async';

import 'package:flutter/material.dart';

import '../models/project_model.dart';
import '../services/firestore_service.dart';

class ProjectProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<ProjectModel> _projects = [];
  StreamSubscription<List<ProjectModel>>? _subscription;
  Timer? _loadingTimeout;
  bool _isLoading = false;
  String? _errorMessage;
  ProjectStatus? _filterStatus;

  List<ProjectModel> get allProjects => _projects;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ProjectStatus? get filterStatus => _filterStatus;

  List<ProjectModel> get projects {
    if (_filterStatus == null) {
      return _projects;
    }
    return _projects.where((p) => p.status == _filterStatus).toList();
  }

  List<ProjectModel> byStatus(ProjectStatus status) {
    return _projects.where((p) => p.status == status).toList();
  }

  double get completedEarnings {
    return _projects
        .where((p) => p.status == ProjectStatus.paid)
        .fold<double>(0, (sum, project) => sum + project.amount);
  }

  double get totalEarnings {
    return _projects.fold<double>(0, (sum, project) => sum + project.amount);
  }

  int get pendingTasks {
    return _projects.where((p) => p.status != ProjectStatus.paid).length;
  }

  int get toDoCount => byStatus(ProjectStatus.toDo).length;
  int get inProgressCount => byStatus(ProjectStatus.inProgress).length;
  int get paidCount => byStatus(ProjectStatus.paid).length;

  int get upcomingDeadlines {
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));
    return _projects
        .where((p) => p.status != ProjectStatus.paid)
        .where((p) => p.deadline.isAfter(now.subtract(const Duration(days: 1))))
        .where((p) => p.deadline.isBefore(nextWeek))
        .length;
  }

  void setFilterStatus(ProjectStatus? status) {
    _filterStatus = status;
    notifyListeners();
  }

  void clearFilter() {
    _filterStatus = null;
    notifyListeners();
  }

  void listenToProjects(String userId) {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _loadingTimeout?.cancel();
    _loadingTimeout = Timer(const Duration(seconds: 10), () {
      if (_isLoading) {
        _isLoading = false;
        _errorMessage =
            'Taking too long to load projects. Check internet/Firestore rules.';
        notifyListeners();
      }
    });

    _subscription?.cancel();
    _subscription = _firestoreService.getProjectsStream(userId).listen(
      (projectList) {
        _loadingTimeout?.cancel();
        _projects = projectList;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _loadingTimeout?.cancel();
        _errorMessage = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> addProject({
    required String userId,
    required String clientName,
    required String projectTitle,
    required DateTime deadline,
    required double amount,
    ProjectStatus status = ProjectStatus.toDo,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestoreService.addProject(
        userId: userId,
        clientName: clientName,
        projectTitle: projectTitle,
        deadline: deadline,
        amount: amount,
        status: status,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProjectStatus({
    required String userId,
    required String projectId,
    required ProjectStatus status,
  }) {
    return updateProject(
      userId: userId,
      projectId: projectId,
      updates: {'status': status.value},
    );
  }

  Future<bool> updateProject({
    required String userId,
    required String projectId,
    required Map<String, dynamic> updates,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestoreService.updateProject(userId, projectId, updates);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProject({
    required String userId,
    required String projectId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestoreService.deleteProject(userId, projectId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _loadingTimeout?.cancel();
    _subscription?.cancel();
    super.dispose();
  }
}
