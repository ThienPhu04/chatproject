import 'package:finalproject/features/chat/domain/entities/suggestion.dart';
import 'package:finalproject/features/chat/presentation/widget/suggestion_card.dart';
import 'package:flutter/material.dart';

class SuggestionList extends StatelessWidget {
  final List<Suggestion> suggestions;

  const SuggestionList({super.key, required this.suggestions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return SuggestionCard(suggestion: suggestions[index]);
      },
    );
  }
}