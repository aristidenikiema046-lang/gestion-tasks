import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/login_usecase.dart';
import '../../../../domain/usecases/register_usecase.dart'; // Import nécessaire
import '../../../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase; // Ajouté
  final AuthRepository authRepository;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase, // Ajouté
    required this.authRepository,
  }) : super(AuthInitial()) {
    
    // Écoute des changements d'état de connexion de Firebase au démarrage
    on<AppStarted>((event, emit) async {
      await emit.forEach(
        authRepository.currentUser,
        onData: (user) {
          if (user != null) {
            return Authenticated(user: user);
          } else {
            return Unauthenticated();
          }
        },
      );
    });

    // Gestion de la connexion
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginUseCase.call(event.email, event.password);
        emit(Authenticated(user: user));
      } catch (e) {
        emit(AuthError(message: e.toString().replaceAll("Exception: ", "")));
      }
    });

    // Gestion de l'inscription (NOUVEAU)
    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await registerUseCase.call(event.email, event.password);
        emit(Authenticated(user: user));
      } catch (e) {
        emit(AuthError(message: e.toString().replaceAll("Exception: ", "")));
      }
    });

    // Gestion de la déconnexion
    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      await authRepository.logout();
      emit(Unauthenticated());
    });
  }
}