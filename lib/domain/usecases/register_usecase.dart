import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<UserEntity> call(String email, String password) {
    return repository.registerWithEmailAndPassword(email, password);
  }
}