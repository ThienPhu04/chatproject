import '../entities/app_settings.dart';

abstract class SettingsRepository {
  Future<AppSettings> getSettings();
  Future<void> saveLanguage(String language);
  Future<void> saveTheme(bool isDarkMode);
}