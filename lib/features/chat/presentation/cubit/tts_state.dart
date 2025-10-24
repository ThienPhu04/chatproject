abstract class TtsState {}

class TtsInitial extends TtsState {}

class TtsPlaying extends TtsState {
  final String messageId;
  TtsPlaying(this.messageId);
}

class TtsStopped extends TtsState {}

class TtsPaused extends TtsState {}

class TtsError extends TtsState {
  final String message;
  TtsError(this.message);
}
