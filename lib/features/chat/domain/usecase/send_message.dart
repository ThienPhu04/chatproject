import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<Message> call(String message, List<Message> conversationHistory) async {

    final result = await repository.sendMessage(message, conversationHistory);

    return result;
  }
}