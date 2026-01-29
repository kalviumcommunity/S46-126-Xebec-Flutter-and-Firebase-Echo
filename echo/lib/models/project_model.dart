import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String clientName;
  final String projectTitle;
  final DateTime deadline;
  final double amount;
  final bool isCompleted;

  ProjectModel({
    required this.id,
    required this.clientName,
    required this.projectTitle,
    required this.deadline,
    required this.amount,
    required this.isCompleted,
  });

  // Convert ProjectModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientName': clientName,
      'projectTitle': projectTitle,
      'deadline': Timestamp.fromDate(deadline),
      'amount': amount,
      'isCompleted': isCompleted,
    };
  }

  // Create ProjectModel from Firestore Map
  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'] ?? '',
      clientName: map['clientName'] ?? '',
      projectTitle: map['projectTitle'] ?? '',
      deadline: (map['deadline'] as Timestamp).toDate(),
      amount: (map['amount'] ?? 0).toDouble(),
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  // Create ProjectModel from Firestore DocumentSnapshot
  factory ProjectModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProjectModel.fromMap(data);
  }

  // CopyWith method for updating instances
  ProjectModel copyWith({
    String? id,
    String? clientName,
    String? projectTitle,
    DateTime? deadline,
    double? amount,
    bool? isCompleted,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      projectTitle: projectTitle ?? this.projectTitle,
      deadline: deadline ?? this.deadline,
      amount: amount ?? this.amount,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
