import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<TaskEntity>> getTasks(String userId) {
    return remoteDataSource.getTasks(userId);
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    final model = TaskModel(
      id: task.id,
      title: task.title,
      isCompleted: task.isCompleted,
      userId: task.userId,
    );
    return await remoteDataSource.addTask(model);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final model = TaskModel(
      id: task.id,
      title: task.title,
      isCompleted: task.isCompleted,
      userId: task.userId,
    );
    return await remoteDataSource.updateTask(model);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    return await remoteDataSource.deleteTask(taskId);
  }
}