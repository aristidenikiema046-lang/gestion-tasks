import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> loginWithEmailAndPassword(String email, String password);
  Future<UserEntity> registerWithEmailAndPassword(String email, String password);
  Future<void> logout();
  Stream<UserEntity?> get currentUser;
}