import 'package:finalproject/features/auth/domain/entities/user.dart';
import 'package:finalproject/features/auth/domain/repositories/auth_repository.dart';

class LoginWithFacebook {
  final AuthRepository repository;

  LoginWithFacebook(this.repository);

  Future<User> call() async {
    return await repository.loginWithFacebook();
  }
}