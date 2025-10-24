import '../../domain/entities/message.dart';
import '../../domain/entities/suggestion.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';
import '../datasources/suggestion_local_datasource.dart';
import '../model/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final SuggestionLocalDataSource suggestionDataSource;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.suggestionDataSource,
  });

  @override
  Future<Message> sendMessage(
      String message,
      List<Message> conversationHistory,
      ) async {
    final historyModels = conversationHistory
        .map((msg) => MessageModel(
      id: msg.id,
      text: msg.text,
      isUser: msg.isUser,
      timestamp: msg.timestamp,
      hiveStatus: MessageModel.mapToHiveStatus(msg.status),
    ))
        .toList();

    return await remoteDataSource.sendMessage(message, historyModels);
  }

  @override
  List<Suggestion> getSuggestions() {
    return suggestionDataSource.getSuggestions();
  }
}