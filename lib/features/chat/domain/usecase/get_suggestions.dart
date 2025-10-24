import '../entities/suggestion.dart';
import '../repositories/chat_repository.dart';

class GetSuggestions {
  final ChatRepository repository;

  GetSuggestions(this.repository);

  List<Suggestion> call() {
    return repository.getSuggestions();
  }
}