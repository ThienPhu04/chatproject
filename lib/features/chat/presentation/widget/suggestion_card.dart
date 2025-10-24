import 'package:finalproject/features/chat/domain/entities/suggestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/chat_cubit.dart';

class SuggestionCard extends StatelessWidget {
  final Suggestion suggestion;

  const SuggestionCard({super.key, required this.suggestion});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(suggestion.icon, style: TextStyle(fontSize: 24)),
              SizedBox(width: 8),
              Text(
                suggestion.title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ...suggestion.items.map((item) => GestureDetector(
            onTap: () {
              context.read<ChatCubit>().selectSuggestion(item);
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(item, style: TextStyle(fontSize: 14, color: Colors.black)),
            ),
          )),
        ],
      ),
    );
  }
}