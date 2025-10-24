import 'package:bloc/bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../chat_history/domain/repositories/chat_history_repository.dart';
import '../../../chat_history/domain/usecase/save_message.dart' as history;
import '../../domain/entities/message.dart';
import '../../domain/usecase/get_suggestions.dart';
import '../../domain/usecase/send_message.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SendMessage sendMessageUseCase;
  final GetSuggestions getSuggestionsUseCase;
  final history.SaveMessage saveMessageUseCase;
  final ChatHistoryRepository historyRepository;

  final List<Message> _messages = [];
  String? _currentSessionId;

  ChatCubit({
    required this.sendMessageUseCase,
    required this.getSuggestionsUseCase,
    required this.saveMessageUseCase,
    required this.historyRepository,
  }) : super(ChatInitial([])) {
    _loadSuggestions();
    _initializeSession();
  }

  void _loadSuggestions() {
    final suggestions = getSuggestionsUseCase();
    emit(ChatInitial(suggestions));
  }

  Future<void> _initializeSession() async {
    final currentSession = await historyRepository.getCurrentSession();
    if (currentSession != null) {
      _currentSessionId = currentSession.id;
      await loadSessionMessages(currentSession.id);
    }
  }

  Future<void> loadSessionMessages(String sessionId) async {
    try {
      _currentSessionId = sessionId;
      await historyRepository.setCurrentSession(sessionId);

      final messages = await historyRepository.getSessionMessages(sessionId);
      _messages.clear();
      _messages.addAll(messages);

      if (_messages.isEmpty) {
        _loadSuggestions();
      } else {
        emit(ChatLoaded(List.from(_messages)));
      }
    } catch (e) {
      emit(ChatError(e.toString(), List.from(_messages)));
    }
  }


  Future<void> startNewChat() async {
    _messages.clear();
    _currentSessionId = null;
    await historyRepository.setCurrentSession(null);
    _loadSuggestions();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Create or get session
    if (_currentSessionId == null) {
      final session = await historyRepository.createSession();
      _currentSessionId = session.id;
    }

    // Create user message
    final userMessage = Message(
      id: const Uuid().v4(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    _messages.add(userMessage);
    emit(ChatLoaded(List.from(_messages)));

    // Save user message to history
    await saveMessageUseCase(_currentSessionId!, userMessage);

    // Create temporary assistant message with loading state
    final tempAssistantMessage = Message(
      id: const Uuid().v4(),
      text: 'Thinking...',
      isUser: false,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );

    _messages.add(tempAssistantMessage);
    emit(ChatLoading(List.from(_messages)));

    try {
      final response = await sendMessageUseCase(text, _messages.where((m) => m.id != tempAssistantMessage.id).toList());

      _messages.removeLast();

      _messages.add(response);
      emit(ChatLoaded(List.from(_messages)));

      // Save assistant message to history
      await saveMessageUseCase(_currentSessionId!, response);

      // Auto-generate title for first message
      if (_messages.length == 2) {
        await _generateSessionTitle(text);
      }

    } catch (e) {
      _messages.removeLast();

      // Add error message
      final errorMessage = Message(
        id: const Uuid().v4(),
        text: 'Sorry, I encountered an error: ${e.toString()}',
        isUser: false,
        timestamp: DateTime.now(),
        status: MessageStatus.error,
      );

      _messages.add(errorMessage);
      emit(ChatError(e.toString(), List.from(_messages)));
    }
  }
  Future<void> _generateSessionTitle(String firstMessage) async {
    if (_currentSessionId == null) return;

    String title = firstMessage.length > 30
        ? '${firstMessage.substring(0, 30)}...'
        : firstMessage;

    await historyRepository.updateSessionTitle(_currentSessionId!, title);
  }

  void selectSuggestion(String suggestion) {
    sendMessage(suggestion);
  }

  void clearChat() {
    _messages.clear();
    _loadSuggestions();
  }
}