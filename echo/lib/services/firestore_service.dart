import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _projectsCollection = 'projects';

  /// Adds a new project to the 'projects' collection
  /// Returns the document ID of the newly created project
  Future<String> addProject({
    required String userId,
    required String clientName,
    required String projectTitle,
    required DateTime deadline,
    required double amount,
    bool isCompleted = false,
  }) async {
    try {
      final docRef = await _firestore.collection(_projectsCollection).add({
        'userId': userId,
        'clientName': clientName,
        'projectTitle': projectTitle,
        'deadline': Timestamp.fromDate(deadline),
        'amount': amount,
        'isCompleted': isCompleted,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      // Update the document with its own ID
      await docRef.update({'id': docRef.id});
      
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add project: $e');
    }
  }

  /// Returns a Stream of List<ProjectModel> for the current user
  /// The stream updates in real-time whenever the data changes in Firestore
  Stream<List<ProjectModel>> getProjectsStream(String userId) {
    try {
      return _firestore
          .collection(_projectsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id; // Ensure the ID is set
          return ProjectModel.fromMap(data);
        }).toList();
      });
    } catch (e) {
      throw Exception('Failed to get projects stream: $e');
    }
  }

  /// Optional: Update an existing project
  Future<void> updateProject(String projectId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(_projectsCollection).doc(projectId).update(updates);
    } catch (e) {
      throw Exception('Failed to update project: $e');
    }
  }

  /// Optional: Delete a project
  Future<void> deleteProject(String projectId) async {
    try {
      await _firestore.collection(_projectsCollection).doc(projectId).delete();
    } catch (e) {
      throw Exception('Failed to delete project: $e');
    }
  }

  /// Optional: Get a single project by ID
  Future<ProjectModel?> getProjectById(String projectId) async {
    try {
      final doc = await _firestore.collection(_projectsCollection).doc(projectId).get();
      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return ProjectModel.fromMap(data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get project: $e');
    }
  }
}
