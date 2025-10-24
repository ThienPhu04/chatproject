import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppSplash());

  static const String _keyWelcomeViewCount = 'welcome_view_count';

  Future<void> initApp() async {
    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();
    final viewCount = prefs.getInt(_keyWelcomeViewCount) ?? 0;

    if (viewCount < 3) {
      emit(AppOnboarding());
    } else {
      final isAuthenticated = false;

      if (isAuthenticated) {
        emit(AppAuthenticated());
      } else {
        emit(AppUnauthenticated());
      }
    }
  }

  Future<void> completeWelcome() async {
    final prefs = await SharedPreferences.getInstance();
    final viewCount = prefs.getInt(_keyWelcomeViewCount) ?? 0;
    await prefs.setInt(_keyWelcomeViewCount, viewCount + 1);

    if (viewCount + 1 < 3) {
      emit(AppUnauthenticated());
    } else {
      emit(AppUnauthenticated());
    }
  }

  Future<void> skipWelcome() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyWelcomeViewCount, 3);
    emit(AppUnauthenticated());
  }

  void navigateToAuth() {
    emit(AppUnauthenticated());
  }

  void navigateToChat() {
    emit(AppAuthenticated());
  }
}