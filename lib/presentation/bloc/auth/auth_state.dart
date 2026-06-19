import '../../../../domain/entities/user_entity.dart';

abstract class AuthState {}

// État initial (l'application vérifie si un utilisateur existe)
class AuthInitial extends AuthState {}

// État pendant une requête réseau (chargement)
class AuthLoading extends AuthState {}

// État lorsque l'utilisateur est connecté avec succès
class Authenticated extends AuthState {
  final UserEntity user;

  Authenticated({required this.user});
}

// État lorsque l'utilisateur n'est pas connecté (affiche l'écran de login)
class Unauthenticated extends AuthState {}

// État en cas d'erreur (mauvais mot de passe, email invalide, etc.)
class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}