class AppSettings {
  final String language;
  final bool isDarkMode;

  AppSettings({
    required this.language,
    required this.isDarkMode,
  });

  AppSettings copyWith({
    String? language,
    bool? isDarkMode,
  }) {
    return AppSettings(
      language: language ?? this.language,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}