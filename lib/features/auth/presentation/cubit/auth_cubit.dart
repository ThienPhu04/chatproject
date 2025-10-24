import 'package:finalproject/features/auth/domain/usecase/get_current_user.dart';
import 'package:finalproject/features/auth/domain/usecase/login_with_apple.dart';
import 'package:finalproject/features/auth/domain/usecase/login_with_email.dart';
import 'package:finalproject/features/auth/domain/usecase/login_with_facebook.dart';
import 'package:finalproject/features/auth/domain/usecase/login_with_google.dart';
import 'package:finalproject/features/auth/domain/usecase/register_with_email.dart';
import 'package:finalproject/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/logout.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginWithEmail loginWithEmailUseCase;
  final RegisterWithEmail registerWithEmailUseCase;
  final LoginWithGoogle loginWithGoogleUseCase;
  final LoginWithFacebook loginWithFacebookUseCase;
  final LoginWithApple loginWithAppleUseCase;
  final Logout logoutUseCase;
  final GetCurrentUser getCurrentUserUseCase;

  AuthCubit({
    required this.loginWithEmailUseCase,
    required this.registerWithEmailUseCase,
    required this.loginWithGoogleUseCase,
    required this.loginWithFacebookUseCase,
    required this.loginWithAppleUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    try {
      final user = await getCurrentUserUseCase();
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await loginWithEmailUseCase(email, password);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> registerWithEmail(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      final user = await registerWithEmailUseCase(email, password, name);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(AuthLoading());
    try {
      final user = await loginWithGoogleUseCase();
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> loginWithFacebook() async {
    emit(AuthLoading());
    try {
      final user = await loginWithFacebookUseCase();
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> loginWithApple() async {
    emit(AuthLoading());
    try {
      final user = await loginWithAppleUseCase();
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> logout() async {
    try {
      await logoutUseCase();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void resetState() {
    emit(AuthInitial());
  }
}