abstract class AuthEvent {}

// Événement déclenché au démarrage pour vérifier si un utilisateur est déjà connecté
class AppStarted extends AuthEvent {}

// Événement déclenché lors de la soumission du formulaire de connexion
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

// Événement déclenché lors de l'inscription
class RegisterRequested extends AuthEvent {
  final String email;
  final String password;

  RegisterRequested({required this.email, required this.password});
}

// Événement déclenché lors de la déconnexion
class LogoutRequested extends AuthEvent {}