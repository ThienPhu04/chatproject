import '../../domain/entities/app_settings.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final AppSettings settings;
  SettingsLoaded(this.settings);
}

class SettingsError extends SettingsState {
  final String message;
  SettingsError(this.message);
}