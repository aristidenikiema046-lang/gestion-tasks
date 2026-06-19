import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.title,
    required super.isCompleted,
    required super.userId,
  });

  // Convertit un document Firestore (JSON) en modèle Dart
  factory TaskModel.fromJson(Map<String, dynamic> json, String documentId) {
    return TaskModel(
      id: documentId,
      title: json['title'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      userId: json['userId'] ?? '',
    );
  }

  // Convertit notre modèle Dart en JSON pour l'envoyer à Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'userId': userId,
    };
  }
}