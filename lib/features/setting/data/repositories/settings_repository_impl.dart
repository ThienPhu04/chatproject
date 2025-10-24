import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);

  @override
  Future<AppSettings> getSettings() async {
    final language = await localDataSource.getLanguage();
    final isDarkMode = await localDataSource.getTheme();

    return AppSettings(
      language: language,
      isDarkMode: isDarkMode,
    );
  }

  @override
  Future<void> saveLanguage(String language) async {
    await localDataSource.saveLanguage(language);
  }

  @override
  Future<void> saveTheme(bool isDarkMode) async {
    await localDataSource.saveTheme(isDarkMode);
  }
}