import '../repositories/settings_repository.dart';

class ChangeTheme {
  final SettingsRepository repository;

  ChangeTheme(this.repository);

  Future<void> call(bool isDarkMode) async {
    await repository.saveTheme(isDarkMode);
  }
}