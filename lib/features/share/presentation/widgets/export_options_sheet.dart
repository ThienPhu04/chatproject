import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/share_cubit.dart';
import '../cubit/share_state.dart';

class ExportOptionsSheet extends StatelessWidget {
  final String sessionId;
  final String sessionTitle;

  const ExportOptionsSheet({
    Key? key,
    required this.sessionId,
    required this.sessionTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShareCubit, ShareState>(
      listener: (context, state) {
        if (state is ShareSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(state.message),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        // Xử lý khi có lỗi
        else if (state is ShareError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }
        // Xử lý khi user cancel share
        else if (state is ShareCancelled) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã hủy chia sẻ'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ShareGenerating || state is ShareSharing;

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Xuất đoạn chat',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!isLoading)
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Session title
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline,
                          size: 20,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            sessionTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Loading indicator
                  if (isLoading)
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state is ShareGenerating
                                ? 'Đang tạo link chia sẻ...'
                                : 'Đang mở ứng dụng...',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    )
                  else ...[
                    // Option 1: Share qua ứng dụng
                    _buildOption(
                      context: context,
                      icon: Icons.share,
                      iconColor: Colors.blue,
                      title: 'Chia sẻ qua ứng dụng',
                      subtitle: 'Zalo, Messenger, Email, WhatsApp, v.v.',
                      onTap: () => _shareViaApps(context),
                    ),

                    // Option 2: Copy link
                    _buildOption(
                      context: context,
                      icon: Icons.link,
                      iconColor: Colors.green,
                      title: 'Sao chép link',
                      subtitle: 'Tạo link và sao chép vào clipboard',
                      onTap: () => _copyLink(context),
                    ),

                    // Option 3: Export as text
                    _buildOption(
                      context: context,
                      icon: Icons.text_snippet,
                      iconColor: Colors.orange,
                      title: 'Xuất dạng văn bản',
                      subtitle: 'Sao chép toàn bộ nội dung chat',
                      onTap: () => _exportAsText(context),
                    ),

                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Build option item
  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Icon container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Arrow icon
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  // Option 1: Share qua các ứng dụng
  void _shareViaApps(BuildContext context) {
    HapticFeedback.lightImpact();
    context.read<ShareCubit>().shareChatSession(
      sessionId: sessionId,
      sessionTitle: sessionTitle,
    );
  }

  // Option 2: Copy link vào clipboard
  Future<void> _copyLink(BuildContext context) async {
    HapticFeedback.lightImpact();

    final shareCubit = context.read<ShareCubit>();
    // Trigger share to generate link
    shareCubit.shareChatSession(
      sessionId: sessionId,
      sessionTitle: sessionTitle,
    );

    // Wait a moment for link generation
    await Future.delayed(const Duration(milliseconds: 800));

    final state = shareCubit.state;
    if (state is ShareGenerated) {
      await Clipboard.setData(ClipboardData(text: state.deepLink));

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Đã sao chép link vào clipboard'),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Xem',
              textColor: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Link chia sẻ'),
                    content: SelectableText(state.deepLink),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Đóng'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }
    }
  }

  // Option 3: Export as plain text
  Future<void> _exportAsText(BuildContext context) async {
    HapticFeedback.lightImpact();
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xuất văn bản'),
        content: const Text(
          'Tính năng này sẽ xuất toàn bộ nội dung chat thành văn bản thuần.\n\n'
              'Bạn có muốn tiếp tục?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performTextExport(context);
            },
            child: const Text('Xuất'),
          ),
        ],
      ),
    );
  }

  Future<void> _performTextExport(BuildContext context) async {

    /*
    // 1. Get messages from session
    final messagesResult = await di.sl<GetSessionMessages>()(sessionId);

    messagesResult.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${failure.message}')),
        );
      },
      (messages) {
        // 2. Format messages as text
        final buffer = StringBuffer();
        buffer.writeln('=== $sessionTitle ===\n');

        for (final message in messages) {
          final sender = message.isUser ? 'Bạn' : 'AI';
          buffer.writeln('[$sender]: ${message.content}');
          buffer.writeln();
        }

        final text = buffer.toString();

        // 3. Copy to clipboard
        Clipboard.setData(ClipboardData(text: text));

        // 4. Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã sao chép nội dung chat'),
            backgroundColor: Colors.green,
          ),
        );
      },
    );
    */

    // Placeholder for now
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng đang được phát triển'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}