import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_event.dart';
import 'task_state.dart';
import '../../../domain/usecases/get_tasks_usecase.dart';
import '../../../domain/usecases/add_task_usecase.dart';
import '../../../domain/usecases/update_task_usecase.dart';
import '../../../domain/usecases/delete_task_usecase.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasksUseCase getTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;

  StreamSubscription? _tasksSubscription;

  TaskBloc({
    required this.getTasksUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
  }) : super(TaskLoadingState()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<OnTasksUpdatedEvent>(_onTasksUpdated);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  void _onLoadTasks(LoadTasksEvent event, Emitter<TaskState> emit) {
    emit(TaskLoadingState());
    _tasksSubscription?.cancel();
    _tasksSubscription = getTasksUseCase(event.userId).listen((tasksList) {
      add(OnTasksUpdatedEvent(tasksList));
    }, onError: (error) {
      add(OnTasksUpdatedEvent(const []));
    });
  }

  void _onTasksUpdated(OnTasksUpdatedEvent event, Emitter<TaskState> emit) {
    emit(TaskLoadedState(event.tasks));
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await addTaskUseCase(event.task);
    } catch (e) {
      emit(const TaskErrorState("Impossible d'ajouter la tâche."));
    }
  }

  Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await updateTaskUseCase(event.task);
    } catch (e) {
      emit(const TaskErrorState("Impossible de modifier la tâche."));
    }
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await deleteTaskUseCase(event.taskId);
    } catch (e) {
      emit(const TaskErrorState("Impossible de supprimer la tâche."));
    }
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}