import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithEmailAndPassword(String email, String password);
  Future<UserModel> registerWithEmailAndPassword(String email, String password);
  Future<void> logout();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSourceImpl({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<UserModel> loginWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        return UserModel.fromFirebase(credential.user!);
      } else {
        throw Exception("Utilisateur introuvable.");
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Erreur de connexion.");
    }
  }

  @override
  Future<UserModel> registerWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        return UserModel.fromFirebase(credential.user!);
      } else {
        throw Exception("Impossible de créer le compte.");
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Erreur d'inscription.");
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser != null) {
        return UserModel.fromFirebase(firebaseUser);
      }
      return null;
    });
  }
}