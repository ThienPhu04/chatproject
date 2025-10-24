import 'package:equatable/equatable.dart';
import 'package:finalproject/features/share/domain/repositories/share_repository.dart';

class ShareChat {
  final ShareRepository repository;

  ShareChat(this.repository);

  @override
  Future<bool> call(ShareChatParams params) async {
    return await repository.shareChat(params.deepLink, params.text);
  }
}

class ShareChatParams extends Equatable {
  final String deepLink;
  final String text;

  const ShareChatParams({
    required this.deepLink,
    required this.text,
  });

  @override
  List<Object?> get props => [deepLink, text];
}