import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository repository;

  GetTasksUseCase(this.repository);

  // La fonction "call" permet d'appeler cette classe comme une fonction directe
  Stream<List<TaskEntity>> call(String userId) {
    return repository.getTasks(userId);
  }
}