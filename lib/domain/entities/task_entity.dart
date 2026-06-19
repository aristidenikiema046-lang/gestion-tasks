import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;
  final String userId; // Crucial pour l'isolation des données demandée !

  const TaskEntity({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.userId,
  });

  @override
  List<Object?> get props => [id, title, isCompleted, userId];
}