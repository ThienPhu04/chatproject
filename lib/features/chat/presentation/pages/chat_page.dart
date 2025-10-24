import 'package:finalproject/app_export.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String? initialSessionId;

  const ChatPage({
    super.key,
    this.initialSessionId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FlutterTts _flutterTts = FlutterTts();
  bool _hasLoadedSession = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialSession();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _flutterTts.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _flutterTts.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        bool isDarkMode = false;

        if (state is SettingsLoaded) {
          isDarkMode = state.settings.isDarkMode;
        }

        final backgroundColor = isDarkMode
            ? AppColors.darkBackground
            : AppColors.lightBackground;
        final appBarColor =
        isDarkMode ? AppColors.darkSurface : AppColors.lightSurface;
        final textColor =
        isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
        final iconColor =
        isDarkMode ? AppColors.darkOnSurface : AppColors.lightOnSurface;
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: appBarColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.menu, color: iconColor),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            title: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Assets.images.logo.image(
                    width: 20,
                    height: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ChatBot AI',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppTitle.status.tr(),
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.more_vert, color: iconColor),
                onPressed: () => _showTtsSettings(context),
              ),
              // Export/Share Button
              BlocBuilder<ChatHistoryCubit, ChatHistoryState>(
                builder: (context, historyState) {
                  // Chỉ hiện nút share khi có session
                  final hasSession = historyState is ChatHistoryLoaded &&
                      historyState.currentSessionId != null;

                  return IconButton(
                    icon: ImageIcon(
                      AssetImage(Assets.icons.export.path),
                      color: hasSession ? iconColor : iconColor.withOpacity(0.3),
                      size: 24,
                    ),
                    onPressed: hasSession ? () => _showExportOptions(context) : null,
                    tooltip: hasSession ? 'Chia sẻ' : 'Không có đoạn chat',
                  );
                },
              ),
            ],
          ),
          drawer: const AppDrawer(),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: BlocBuilder<ChatCubit, ChatState>(
                    builder: (context, state) {
                      if (state is ChatInitial) {
                        return SuggestionList(suggestions: state.suggestions);
                      } else if (state is ChatLoaded) {
                        return MessageList(messages: state.messages);
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.zero,
                  child: ChatInput(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTtsSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const TtsSettingsSheet(),
    );
  }

  void _showExportOptions(BuildContext context) {
    final historyState = context.read<ChatHistoryCubit>().state;

    // Kiểm tra state và session ID
    if (historyState is! ChatHistoryLoaded ||
        historyState.currentSessionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không có đoạn chat để chia sẻ'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    String sessionTitle = 'Chat Session';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: context.read<ShareCubit>(),
        child: ExportOptionsSheet(
          sessionId: historyState.currentSessionId!,
          sessionTitle: sessionTitle,
        ),
      ),
    );
  }

  void _loadInitialSession() {
    if (widget.initialSessionId != null && !_hasLoadedSession) {
      _hasLoadedSession = true;

      try {
        final chatHistoryCubit = context.read<ChatHistoryCubit>();
        final chatCubit = context.read<ChatCubit>();
        chatHistoryCubit.loadSessionById(widget.initialSessionId!);
        chatCubit.loadSessionMessages(widget.initialSessionId!);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Đã tải đoạn chat được chia sẻ'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        // Show thông báo lỗi nếu không load được
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Không thể tải đoạn chat: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}