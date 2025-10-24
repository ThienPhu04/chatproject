import 'package:bloc/bloc.dart';
import 'package:finalproject/features/setting/domain/usecase/update_language.dart';
import 'package:finalproject/features/setting/domain/usecase/update_theme.dart';

import '../../domain/usecase/get_settings.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettings getSettingsUseCase;
  final ChangeLanguage saveLanguageUseCase;
  final ChangeTheme saveThemeUseCase;

  SettingsCubit({
    required this.getSettingsUseCase,
    required this.saveLanguageUseCase,
    required this.saveThemeUseCase,
  }) : super(SettingsInitial());

  Future<void> loadSettings() async {
    emit(SettingsLoading());
    try {
      final settings = await getSettingsUseCase();
      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> changeLanguage(String language) async {
    try {
      await saveLanguageUseCase(language);
      await loadSettings();
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> changeTheme(bool isDarkMode) async {
    try {
      await saveThemeUseCase(isDarkMode);
      await loadSettings();
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
}