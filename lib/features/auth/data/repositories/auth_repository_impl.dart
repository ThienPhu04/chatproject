import 'package:finalproject/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:finalproject/features/auth/domain/entities/user.dart';
import 'package:finalproject/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> loginWithEmail(String email, String password) async {
    return await remoteDataSource.loginWithEmail(email, password);
  }

  @override
  Future<User> registerWithEmail(String email, String password, String name) async {
    return await remoteDataSource.registerWithEmail(email, password, name);
  }

  @override
  Future<User> loginWithGoogle() async {
    return await remoteDataSource.loginWithGoogle();
  }

  @override
  Future<User> loginWithFacebook() async {
    return await remoteDataSource.loginWithFacebook();
  }

  @override
  Future<User> loginWithApple() async {
    return await remoteDataSource.loginWithApple();
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }

  @override
  Future<User?> getCurrentUser() async {
    return await remoteDataSource.getCurrentUser();
  }
}
