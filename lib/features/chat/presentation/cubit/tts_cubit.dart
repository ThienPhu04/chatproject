import 'package:bloc/bloc.dart';
import 'package:finalproject/core/services/tts_service.dart';
import 'tts_state.dart';

class TtsCubit extends Cubit<TtsState> {
  final TtsService ttsService;

  TtsCubit(this.ttsService) : super(TtsInitial());

  Future<void> initialize() async {
    try {
      await ttsService.initialize();
      emit(TtsStopped());
    } catch (e) {
      emit(TtsError(e.toString()));
    }
  }

  Future<void> speak(String text, String messageId) async {
    try {
      emit(TtsPlaying(messageId));
      await ttsService.speak(text, messageId);
    } catch (e) {
      emit(TtsError(e.toString()));
      emit(TtsStopped());
    }
  }

  Future<void> stop() async {
    try {
      await ttsService.stop();
      emit(TtsStopped());
    } catch (e) {
      emit(TtsError(e.toString()));
    }
  }

  Future<void> pause() async {
    try {
      await ttsService.pause();
      emit(TtsPaused());
    } catch (e) {
      emit(TtsError(e.toString()));
    }
  }

  bool isPlayingMessage(String messageId) {
    return state is TtsPlaying &&
        (state as TtsPlaying).messageId == messageId;
  }
}