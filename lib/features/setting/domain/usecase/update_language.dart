import '../repositories/settings_repository.dart';

class ChangeLanguage {
  final SettingsRepository repository;

  ChangeLanguage(this.repository);

  Future<void> call(String language) async {
    await repository.saveLanguage(language);
  }
}