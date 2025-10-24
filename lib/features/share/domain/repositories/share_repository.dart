import '../entities/share_content.dart';

abstract class ShareRepository {
  /// Generate a deep link for sharing chat
  Future<String> generateShareLink(ShareContent content);

  /// Share chat via native share dialog
  Future<bool> shareChat(String deepLink, String text);

  /// Parse deep link to get share content
  Future<ShareContent> parseShareLink(String deepLink);
}