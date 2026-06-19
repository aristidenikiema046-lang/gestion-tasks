import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_entity.dart';

abstract class TaskState extends Equatable {
  const TaskState();
  
  @override
  List<Object?> get props => [];
}

// État 1 : L'application est en train de charger les données (on affichera un spinner)
class TaskLoadingState extends TaskState {}

// État 2 : Les données sont chargées avec succès (on affichera la liste des tâches)
class TaskLoadedState extends TaskState {
  final List<TaskEntity> tasks;
  const TaskLoadedState(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

// État 3 : Une erreur est survenue (pas de réseau, problème Firebase, etc.)
class TaskErrorState extends TaskState {
  final String message;
  const TaskErrorState(this.message);

  @override
  List<Object?> get props => [message];
}