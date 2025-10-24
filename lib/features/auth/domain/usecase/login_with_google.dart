import 'package:finalproject/features/auth/domain/entities/user.dart';
import 'package:finalproject/features/auth/domain/repositories/auth_repository.dart';

class LoginWithGoogle {
  final AuthRepository repository;

  LoginWithGoogle(this.repository);

  Future<User> call() async {
    return await repository.loginWithGoogle();
  }
}