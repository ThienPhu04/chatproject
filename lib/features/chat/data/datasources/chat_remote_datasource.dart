import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/config/env_config.dart';
import '../model/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<MessageModel> sendMessage(
      String message,
      List<MessageModel> conversationHistory,
      );
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  final http.Client client;

  ChatRemoteDataSourceImpl({http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<MessageModel> sendMessage(
      String message,
      List<MessageModel> conversationHistory,
      ) async {
    try {
      final apiKey = EnvConfig.openAiApiKey;
      if (apiKey.isEmpty) {
        throw Exception('Gemini API key not found');
      }

      final StringBuffer promptText = StringBuffer();
      promptText.writeln('You are a helpful AI assistant. Be concise and friendly.');
      for (var msg in conversationHistory) {
        final role = msg.isUser ? 'User' : 'Assistant';
        promptText.writeln('$role: ${msg.text}');
      }
      promptText.writeln('User: $message');

      final body = {
        "contents": [
          {
            "parts": [
              {"text": promptText.toString()}
            ]
          }
        ]
      };

      final response = await client.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-goog-api-key': apiKey,
        },
        body: jsonEncode(body),
      );

      debugPrint("Status code: ${response.statusCode}");
      debugPrint("Body: ${response.body}", wrapWidth: 1024);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rawText = data['candidates'][0]['content']['parts'][0]['text'] as String;
        final assistantMessage = cleanText(rawText);


        return MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: assistantMessage,
          isUser: false,
          timestamp: DateTime.now(),
          hiveStatus: MessageStatusHive.sent,
        );
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error']['message'] ?? 'Failed to get response');
      }
    } catch (e) {
      throw Exception('Error communicating with Gemini: ${e.toString()}');
    }
  }
}
String cleanText(String text) {
  return text
      .replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'$1')
      .replaceAll(RegExp(r'\*(.*?)\*'), r'$1');
}

