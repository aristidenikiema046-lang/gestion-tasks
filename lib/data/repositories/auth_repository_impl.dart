import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> loginWithEmailAndPassword(String email, String password) async {
    return await remoteDataSource.loginWithEmailAndPassword(email, password);
  }

  @override
  Future<UserEntity> registerWithEmailAndPassword(String email, String password) async {
    return await remoteDataSource.registerWithEmailAndPassword(email, password);
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }

  @override
  Stream<UserEntity?> get currentUser {
    return remoteDataSource.authStateChanges;
  }
}