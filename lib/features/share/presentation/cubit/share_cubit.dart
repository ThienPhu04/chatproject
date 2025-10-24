import 'package:bloc/bloc.dart';
import 'package:finalproject/features/share/presentation/cubit/share_state.dart';
import '../../data/repositories/share_repository_impl.dart';
import '../../domain/entities/share_content.dart';

class ShareCubit extends Cubit<ShareState> {
  final ShareRepositoryImpl repository;

  ShareCubit({required this.repository}) : super(ShareInitial());

  Future<void> shareChatSession({
    required String sessionId,
    required String sessionTitle,
    List<String>? messageIds,
  }) async {
    emit(ShareGenerating());

    try {
      final messagesToShare = messageIds ?? [];

      final content = ShareContent(
        sessionId: sessionId,
        title: sessionTitle,
        messageIds: messagesToShare,
        sharedAt: DateTime.now(),
      );

      final deepLink = await repository.generateShareLink(content);
      emit(ShareGenerated(deepLink: deepLink));

      emit(ShareSharing());
      final success = await repository.shareChat(
        deepLink,
        '',
      );

      if (success) {
        emit(const ShareSuccess());
      } else {
        emit(ShareCancelled());
      }
    } catch (e) {
      emit(ShareError(message: 'Lỗi khi chia sẻ: $e'));
    }
  }

  void reset() {
    emit(ShareInitial());
  }
}