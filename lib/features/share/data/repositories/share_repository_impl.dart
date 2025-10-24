import 'package:finalproject/features/share/domain/entities/share_content.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/repositories/share_repository.dart';
import '../datasources/share_datasource.dart';

class ShareRepositoryImpl implements ShareRepository{
  final ShareDataSource dataSource;

  ShareRepositoryImpl({required this.dataSource});

  Future<String> generateShareLink(ShareContent content) async {
    try {
      return dataSource.generateDeepLink(content);
    } catch (e) {
      throw Exception('Failed to generate share link: $e');
    }
  }

  Future<bool> shareChat(String deepLink, String text) async {
    try {
      final result = await dataSource.shareContent(
        '$text\n\n$deepLink',
        subject: 'Chia sẻ đoạn chat',
      );
      return result.status == ShareResultStatus.success;
    } catch (e) {
      throw Exception('Failed to share chat: $e');
    }
  }

  Future<ShareContent> parseShareLink(String deepLink) async {
    try {
      return dataSource.parseDeepLink(deepLink);
    } catch (e) {
      throw Exception('Failed to parse share link: $e');
    }
  }
}