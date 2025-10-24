import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/share_content.dart';

class ShareDataSource {
  final String scheme;

  ShareDataSource({required this.scheme});

  // Generate deep link from share content
  String generateDeepLink(ShareContent content) {
    final jsonString = jsonEncode(content.toJson());
    final base64Data = base64Url.encode(utf8.encode(jsonString));
    return '$scheme:///share?data=$base64Data';
  }

  // Share content using share_plus
  Future<ShareResult> shareContent(String text, {String? subject}) async {
    final params = ShareParams(
      text: text,
      subject: subject,
    );
    // return await Share.share(text, subject: subject);
    return await SharePlus.instance.share(params);
  }

  // Parse deep link to get share content
  ShareContent parseDeepLink(String deepLink) {
    final uri = Uri.parse(deepLink);

    if (uri.scheme != scheme || uri.path != '/share') {
      throw Exception('Invalid deep link format');
    }

    final base64Data = uri.queryParameters['data'];
    if (base64Data == null) {
      throw Exception('No data in deep link');
    }

    final jsonString = utf8.decode(base64Url.decode(base64Data));
    final json = jsonDecode(jsonString) as Map<String, dynamic>;

    return ShareContent.fromJson(json);
  }
}