import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

// -- IMPORTS DE LA COUCHE DOMAIN --
import 'domain/usecases/get_tasks_usecase.dart';
import 'domain/usecases/add_task_usecase.dart';
import 'domain/usecases/update_task_usecase.dart';
import 'domain/usecases/delete_task_usecase.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/register_usecase.dart'; // NOUVEAU
import 'domain/repositories/auth_repository.dart';

// -- IMPORTS DE LA COUCHE DATA --
import 'data/datasources/task_remote_datasource.dart';
import 'data/repositories/task_repository_impl.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';

// -- IMPORTS DE LA COUCHE PRESENTATION --
import 'presentation/bloc/task_bloc.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/auth/auth_event.dart';
import 'presentation/bloc/auth/auth_state.dart';
import 'presentation/views/task_screen.dart';
import 'presentation/views/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final taskRemoteDataSource = TaskRemoteDataSourceImpl();
  final taskRepository = TaskRepositoryImpl(remoteDataSource: taskRemoteDataSource);

  final authRemoteDataSource = AuthRemoteDataSourceImpl();
  final authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);

  final getTasksUseCase = GetTasksUseCase(taskRepository);
  final addTaskUseCase = AddTaskUseCase(taskRepository);
  final updateTaskUseCase = UpdateTaskUseCase(taskRepository);
  final deleteTaskUseCase = DeleteTaskUseCase(taskRepository);
  final loginUseCase = LoginUseCase(authRepository);
  final registerUseCase = RegisterUseCase(authRepository); // NOUVEAU

  runApp(
    MyApp(
      getTasksUseCase: getTasksUseCase,
      addTaskUseCase: addTaskUseCase,
      updateTaskUseCase: updateTaskUseCase,
      deleteTaskUseCase: deleteTaskUseCase,
      loginUseCase: loginUseCase,
      registerUseCase: registerUseCase, // NOUVEAU
      authRepository: authRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final GetTasksUseCase getTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase; // NOUVEAU
  final AuthRepository authRepository;

  const MyApp({
    super.key,
    required this.getTasksUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
    required this.loginUseCase,
    required this.registerUseCase, // NOUVEAU
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase, // NOUVEAU
            authRepository: authRepository,
          )..add(AppStarted()),
        ),
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(
            getTasksUseCase: getTasksUseCase,
            addTaskUseCase: addTaskUseCase,
            updateTaskUseCase: updateTaskUseCase,
            deleteTaskUseCase: deleteTaskUseCase,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Gestion de Tâches',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) return TaskScreen(userId: state.user.uid);
            if (state is AuthLoading || state is AuthInitial) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}