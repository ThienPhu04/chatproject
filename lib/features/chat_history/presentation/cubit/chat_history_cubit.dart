import 'package:bloc/bloc.dart';
import '../../domain/usecase/create_session.dart';
import '../../domain/usecase/delete_session.dart';
import '../../domain/usecase/get_all_sessions.dart';
import '../../domain/usecase/get_session_messages.dart';
import '../../domain/usecase/update_session_title.dart';
import 'chat_history_state.dart';

class ChatHistoryCubit extends Cubit<ChatHistoryState> {
  final GetAllSessions getAllSessionsUseCase;
  final CreateSession createSessionUseCase;
  final UpdateSessionTitle updateSessionTitleUseCase;
  final DeleteSession deleteSessionUseCase;
  final GetSessionMessages getSessionMessagesUseCase;

  String? _currentSessionId;

  ChatHistoryCubit({
    required this.getAllSessionsUseCase,
    required this.createSessionUseCase,
    required this.updateSessionTitleUseCase,
    required this.deleteSessionUseCase,
    required this.getSessionMessagesUseCase,
  }) : super(ChatHistoryInitial());

  String? get currentSessionId => _currentSessionId;

  Future<void> loadSessions() async {
    emit(ChatHistoryLoading());
    try {
      final sessions = await getAllSessionsUseCase();
      emit(ChatHistoryLoaded(sessions, currentSessionId: _currentSessionId, currentMessages: []));
    } catch (e) {
      emit(ChatHistoryError(e.toString()));
    }
  }

  Future<String> createNewSession() async {
    try {
      final session = await createSessionUseCase();
      _currentSessionId = session.id;
      await loadSessions();
      return session.id;
    } catch (e) {
      emit(ChatHistoryError(e.toString()));
      rethrow;
    }
  }

  Future<void> selectSession(String sessionId) async {
    _currentSessionId = sessionId;
    await loadSessions();
  }

  Future<void> updateTitle(String sessionId, String newTitle) async {
    try {
      await updateSessionTitleUseCase(sessionId, newTitle);
      await loadSessions();
    } catch (e) {
      emit(ChatHistoryError(e.toString()));
    }
  }

  Future<void> deleteSession(String sessionId) async {
    try {
      await deleteSessionUseCase(sessionId);
      if (_currentSessionId == sessionId) {
        _currentSessionId = null;
      }
      await loadSessions();
    } catch (e) {
      emit(ChatHistoryError(e.toString()));
    }
  }

  Future<void> loadSessionById(String sessionId) async {
    emit(ChatHistoryLoading());
    try {
      _currentSessionId = sessionId;
      final sessions = await getAllSessionsUseCase();
      final messages = await getSessionMessagesUseCase(sessionId);
      emit(ChatHistoryLoaded(
        sessions,
        currentSessionId: _currentSessionId,
        currentMessages: messages,
      ));
    } catch (e) {
      emit(ChatHistoryError(e.toString()));
    }
  }
}