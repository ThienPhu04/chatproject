import 'package:finalproject/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> loginWithEmail(String email, String password);
  Future<User> registerWithEmail(String email, String password, String name);
  Future<User> loginWithGoogle();
  Future<User> loginWithFacebook();
  Future<User> loginWithApple();
  Future<void> logout();
  Future<User?> getCurrentUser();
}