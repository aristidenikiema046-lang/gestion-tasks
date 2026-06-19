import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Stream<List<TaskModel>> getTasks(String userId);
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Stream<List<TaskModel>> getTasks(String userId) {
    // Isolation des données : On filtre par userId directement dans Firestore 
    return firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .snapshots() // Écoute en temps réel 
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TaskModel.fromJson(doc.data(), doc.id);
      }).toList();
    });
  }

  @override
  Future<void> addTask(TaskModel task) async {
    await firestore.collection('tasks').add(task.toFirestore());
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await firestore.collection('tasks').doc(task.id).update({
      'isCompleted': task.isCompleted,
    });
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await firestore.collection('tasks').doc(taskId).delete();
  }
}