import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/share/data/repositories/share_repository_impl.dart';
class SharedChatHandler extends StatefulWidget {
  final String encodedData;
  final ShareRepositoryImpl shareRepository;

  const SharedChatHandler({
    super.key,
    required this.encodedData,
    required this.shareRepository,
  });

  @override
  State<SharedChatHandler> createState() => _SharedChatHandlerState();
}

class _SharedChatHandlerState extends State<SharedChatHandler> {
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _handleSharedLink();
  }

  Future<void> _handleSharedLink() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final deepLink = 'final:///share?data=${widget.encodedData}';

      print('Deep link: $deepLink');

      // Parse deep link để lấy share content
      final shareContent = await widget.shareRepository.parseShareLink(deepLink);

      print('Parsed successfully - Session ID: ${shareContent.sessionId}');

      if (mounted) {
        print('Navigating to /chat?sessionId=${shareContent.sessionId}');
        context.go('/chat?sessionId=${shareContent.sessionId}');
      }
    } catch (e) {
      print('Error parsing deep link: $e');

      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Không thể mở link: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                'Đang tải đoạn chat...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Vui lòng đợi trong giây lát',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show error if any
    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Lỗi'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/chat'),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 24),
                Text(
                  'Không thể mở link',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => context.go('/chat'),
                  icon: const Icon(Icons.home),
                  label: const Text('Về trang chủ'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                      _errorMessage = null;
                    });
                    _handleSharedLink();
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class InvalidShareLinkPage extends StatelessWidget {
  const InvalidShareLinkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.link_off,
                size: 80,
                color: Colors.orange[300],
              ),
              const SizedBox(height: 24),
              Text(
                'Link không hợp lệ',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Link chia sẻ không đúng định dạng hoặc thiếu dữ liệu.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.go('/chat'),
                icon: const Icon(Icons.home),
                label: const Text('Về trang chủ'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}