import 'package:finalproject/features/chat/domain/entities/suggestion.dart';

class SuggestionLocalDataSource {
  List<Suggestion> getSuggestions() {
    return [
      Suggestion(
        icon: '📝',
        title: 'Explain',
        items: [
          'Explain Quantum physics',
          'What are wormholes explain like i am 5',
        ],
      ),
      Suggestion(
        icon: '✏️',
        title: 'Write & edit',
        items: [
          'Write a tweet about global warming',
          'Write a poem about flower and love',
          'Write a rap song lyrics about',
        ],
      ),
      Suggestion(
        icon: '🌐',
        title: 'Translate',
        items: [
          'How do you say "how are you" in korean?',
          'Translate "Hello world" to Spanish',
        ],
      ),
    ];
  }
}