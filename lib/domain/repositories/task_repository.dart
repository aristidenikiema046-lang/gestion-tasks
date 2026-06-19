import '../entities/task_entity.dart';

abstract class TaskRepository {
  // 1. Lire les tâches en temps réel (Stream)
  Stream<List<TaskEntity>> getTasks(String userId);
  
  // 2. Créer une tâche
  Future<void> addTask(TaskEntity task);
  
  // 3. Modifier une tâche (ex: cocher la case)
  Future<void> updateTask(TaskEntity task);
  
  // 4. Supprimer une tâche
  Future<void> deleteTask(String taskId);
}