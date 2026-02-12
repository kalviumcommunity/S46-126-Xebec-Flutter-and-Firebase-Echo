import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/client_model.dart';
import '../models/project_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _projectsRef() {
    return _firestore.collection('projects');
  }

  CollectionReference<Map<String, dynamic>> _clientsRef() {
    return _firestore.collection('clients');
  }

  Future<String> addProject({
    required String userId,
    required String clientName,
    required String projectTitle,
    required DateTime deadline,
    required double amount,
    ProjectStatus status = ProjectStatus.toDo,
  }) async {
    final docRef = _projectsRef().doc();
    final project = ProjectModel(
      id: docRef.id,
      clientName: clientName,
      projectTitle: projectTitle,
      deadline: deadline,
      amount: amount,
      status: status,
    );
    final payload = project.toMap();
    payload['userId'] = userId;
    await docRef.set(payload);
    return docRef.id;
  }

  Stream<List<ProjectModel>> getProjectsStream(String userId) {
    return _projectsRef()
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map(ProjectModel.fromFirestore).toList());
  }

  Future<void> updateProject(
    String userId,
    String projectId,
    Map<String, dynamic> updates,
  ) async {
    await _projectsRef().doc(projectId).update(updates);
  }

  Future<void> deleteProject(String userId, String projectId) async {
    await _projectsRef().doc(projectId).delete();
  }

  Future<String> addClient({
    required String userId,
    required String name,
    required String email,
    required String phone,
    required String company,
  }) async {
    final docRef = _clientsRef().doc();
    final client = ClientModel(
      id: docRef.id,
      name: name,
      email: email,
      phone: phone,
      company: company,
    );
    final payload = client.toMap();
    payload['userId'] = userId;
    await docRef.set(payload);
    return docRef.id;
  }

  Stream<List<ClientModel>> getClientsStream(String userId) {
    return _clientsRef()
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map(ClientModel.fromFirestore).toList());
  }

  Future<void> deleteClient(String userId, String clientId) async {
    await _clientsRef().doc(clientId).delete();
  }
}
