import '../entities/message.dart';
import '../entities/suggestion.dart';

abstract class ChatRepository {
  Future<Message> sendMessage(String message, List<Message> conversationHistory);
  List<Suggestion> getSuggestions();
}
