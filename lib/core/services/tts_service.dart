import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;
  String? _currentMessageId;

  bool get isPlaying => _isPlaying;
  String? get currentMessageId => _currentMessageId;

  Future<void> initialize() async {

    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setStartHandler(() {
      _isPlaying = true;
    });

    _flutterTts.setCompletionHandler(() {
      _isPlaying = false;
      _currentMessageId = null;
    });

    _flutterTts.setErrorHandler((msg) {
      _isPlaying = false;
      _currentMessageId = null;
    });
  }

  Future<void> speak(String text, String messageId) async {
    if (_isPlaying) {
      await stop();
    }
    _currentMessageId = messageId;
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    _isPlaying = false;
    _currentMessageId = null;
  }

  Future<void> pause() async {
    await _flutterTts.pause();
    _isPlaying = false;
  }

  Future<void> setLanguage(String language) async {
    await _flutterTts.setLanguage(language);
  }

  Future<void> setSpeechRate(double rate) async {
    await _flutterTts.setSpeechRate(rate);
  }

  Future<void> setVolume(double volume) async {
    await _flutterTts.setVolume(volume);
  }

  Future<void> setPitch(double pitch) async {
    await _flutterTts.setPitch(pitch);
  }

  Future<List<dynamic>> getLanguages() async {
    return await _flutterTts.getLanguages;
  }

  void dispose() {
    _flutterTts.stop();
  }
}