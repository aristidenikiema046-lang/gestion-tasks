import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';

class TaskScreen extends StatefulWidget {
  final String userId; // ID de l'utilisateur connecté pour l'isolation

  const TaskScreen({super.key, required this.userId});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Dès l'ouverture de l'écran, on demande au BLoC de charger les tâches
    context.read<TaskBloc>().add(LoadTasksEvent(widget.userId));
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  // Boîte de dialogue pour ajouter une tâche (avec gestion du cas limite vide)
  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Nouvelle Tâche'),
          content: TextField(
            controller: _taskController,
            decoration: const InputDecoration(
              hintText: 'Entrez le titre de la tâche...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = _taskController.text.trim();
                
                // Cas limite bonus : Formulaire soumis avec un titre vide
                if (title.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Le titre ne peut pas être vide !'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // On crée l'entité pure à envoyer
                final newTask = TaskEntity(
                  id: '', // Firestore générera l'ID automatiquement
                  title: title,
                  isCompleted: false,
                  userId: widget.userId,
                );

                // On envoie l'événement au BLoC via le context d'origine
                context.read<TaskBloc>().add(AddTaskEvent(newTask));
                _taskController.clear();
                Navigator.pop(dialogContext);
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Tâches - HAYATAK"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Se déconnecter",
            onPressed: () {
              // Déclenche l'événement de déconnexion globale
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          
          // 1. Cas limite : État de chargement visible pendant les requêtes
          if (state is TaskLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Cas limite : Gestion des erreurs (perte de connexion, problème Firebase)
          if (state is TaskErrorState) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          // 3. État : Données chargées avec succès
          if (state is TaskLoadedState) {
            final tasks = state.tasks;

            // Cas limite bonus : Liste vide -> affiche un message explicite
            if (tasks.isEmpty) {
              return const Center(
                child: Text(
                  'Aucune tâche disponible.\nCliquez sur + pour en ajouter.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        // Événement de modification mis à jour dans le BLoC
                        final updatedTask = TaskEntity(
                          id: task.id,
                          title: task.title,
                          isCompleted: value ?? false,
                          userId: task.userId,
                        );
                        context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask));
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        // Événement de suppression envoyé au BLoC
                        context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
                      },
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}