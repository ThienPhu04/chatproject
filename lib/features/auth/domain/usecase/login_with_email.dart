import 'package:finalproject/features/auth/domain/entities/user.dart';
import 'package:finalproject/features/auth/domain/repositories/auth_repository.dart';

class LoginWithEmail {
  final AuthRepository repository;

  LoginWithEmail(this.repository);

  Future<User> call(String email, String password) async {
    return await repository.loginWithEmail(email, password);
  }
}