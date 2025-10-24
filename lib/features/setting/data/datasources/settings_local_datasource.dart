import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<String> getLanguage();
  Future<bool> getTheme();
  Future<void> saveLanguage(String language);
  Future<void> saveTheme(bool isDarkMode);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String _languageKey = 'language';
  static const String _themeKey = 'is_dark_mode';

  final SharedPreferences _prefs;

  SettingsLocalDataSourceImpl(this._prefs);

  @override
  Future<String> getLanguage() async {
    return _prefs.getString(_languageKey) ?? 'en';
  }

  @override
  Future<bool> getTheme() async {
    return _prefs.getBool(_themeKey) ?? false;
  }

  @override
  Future<void> saveLanguage(String language) async {
    await _prefs.setString(_languageKey, language);
  }

  @override
  Future<void> saveTheme(bool isDarkMode) async {
    await _prefs.setBool(_themeKey, isDarkMode);
  }
}