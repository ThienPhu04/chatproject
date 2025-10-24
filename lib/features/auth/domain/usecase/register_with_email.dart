import 'package:finalproject/features/auth/domain/entities/user.dart';
import 'package:finalproject/features/auth/domain/repositories/auth_repository.dart';

class RegisterWithEmail {
  final AuthRepository repository;

  RegisterWithEmail(this.repository);

  Future<User> call(String email, String password, String name) async {
    return await repository.registerWithEmail(email, password, name);
  }
}