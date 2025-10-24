import 'package:finalproject/features/auth/domain/entities/user.dart';
import 'package:finalproject/features/auth/domain/repositories/auth_repository.dart';

class LoginWithApple {
  final AuthRepository repository;

  LoginWithApple(this.repository);

  Future<User> call() async {
    return await repository.loginWithApple();
  }
}