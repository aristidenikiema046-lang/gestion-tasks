import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_entity.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

// 1. Événement pour charger/écouter les tâches en temps réel
class LoadTasksEvent extends TaskEvent {
  final String userId;
  const LoadTasksEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

// 2. Événement quand les tâches changent dans Firebase (pour le temps réel)
class OnTasksUpdatedEvent extends TaskEvent {
  final List<TaskEntity> tasks;
  const OnTasksUpdatedEvent(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

// 3. Événement pour ajouter une tâche
class AddTaskEvent extends TaskEvent {
  final TaskEntity task;
  const AddTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

// 4. Événement pour modifier/cocher une tâche
class UpdateTaskEvent extends TaskEvent {
  final TaskEntity task;
  const UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

// 5. Événement pour supprimer une tâche
class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  const DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}