import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get openAiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  static Future<void> printOpenAiApiKey() async {
    await load();
    print(openAiApiKey);
  }

  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }
}