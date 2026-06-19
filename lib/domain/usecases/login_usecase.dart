import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call(String email, String password) async {
    // Une petite validation métier de base avant d'appeler le repository
    if (email.isEmpty || password.isEmpty) {
      throw Exception("L'email et le mot de passe ne peuvent pas être vides.");
    }
    
    return await repository.loginWithEmailAndPassword(email, password);
  }
}