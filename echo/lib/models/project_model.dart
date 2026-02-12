import 'package:cloud_firestore/cloud_firestore.dart';

enum ProjectStatus { toDo, inProgress, paid }

extension ProjectStatusX on ProjectStatus {
  String get value {
    switch (this) {
      case ProjectStatus.toDo:
        return 'toDo';
      case ProjectStatus.inProgress:
        return 'inProgress';
      case ProjectStatus.paid:
        return 'paid';
    }
  }

  String get label {
    switch (this) {
      case ProjectStatus.toDo:
        return 'To-Do';
      case ProjectStatus.inProgress:
        return 'In Progress';
      case ProjectStatus.paid:
        return 'Paid';
    }
  }

  static ProjectStatus fromValue(String? value) {
    switch (value) {
      case 'inProgress':
        return ProjectStatus.inProgress;
      case 'paid':
        return ProjectStatus.paid;
      case 'toDo':
      default:
        return ProjectStatus.toDo;
    }
  }
}

class ProjectModel {
  final String id;
  final String clientName;
  final String projectTitle;
  final DateTime deadline;
  final double amount;
  final ProjectStatus status;
  final DateTime? createdAt;

  const ProjectModel({
    required this.id,
    required this.clientName,
    required this.projectTitle,
    required this.deadline,
    required this.amount,
    required this.status,
    this.createdAt,
  });

  bool get isPaid => status == ProjectStatus.paid;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientName': clientName,
      'projectTitle': projectTitle,
      'deadline': Timestamp.fromDate(deadline),
      'amount': amount,
      'status': status.value,
      'createdAt': createdAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt!),
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    final deadlineRaw = map['deadline'];
    final createdAtRaw = map['createdAt'];

    return ProjectModel(
      id: map['id']?.toString() ?? '',
      clientName: map['clientName']?.toString() ?? '',
      projectTitle: map['projectTitle']?.toString() ?? '',
      deadline: deadlineRaw is Timestamp
          ? deadlineRaw.toDate()
          : deadlineRaw is DateTime
              ? deadlineRaw
              : DateTime.now(),
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      status: ProjectStatusX.fromValue(map['status']?.toString()),
      createdAt: createdAtRaw is Timestamp
          ? createdAtRaw.toDate()
          : createdAtRaw is DateTime
              ? createdAtRaw
              : null,
    );
  }

  factory ProjectModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    data['id'] = doc.id;
    return ProjectModel.fromMap(data);
  }

  ProjectModel copyWith({
    String? id,
    String? clientName,
    String? projectTitle,
    DateTime? deadline,
    double? amount,
    ProjectStatus? status,
    DateTime? createdAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      projectTitle: projectTitle ?? this.projectTitle,
      deadline: deadline ?? this.deadline,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
