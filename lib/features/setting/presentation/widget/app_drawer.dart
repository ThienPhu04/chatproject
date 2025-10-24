import 'package:easy_localization/easy_localization.dart';
import 'package:finalproject/core/constant/constant.dart';
import 'package:finalproject/core/theme/themecolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../chat/presentation/cubit/chat_cubit.dart';
import '../../../chat_history/presentation/cubit/chat_history_cubit.dart';
import '../../../chat_history/presentation/cubit/chat_history_state.dart';
import '../../../chat_history/presentation/widget/session_item.dart';
import 'drawer_footer.dart';
import 'drawer_header.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ChatHistoryCubit>().loadSessions();

    return Drawer(
      child: Column(
        children: [
          // Header - User Info
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              User? user;
              if (state is AuthSuccess) {
                user = state.user;
              }
              return CustomDrawerHeader(user: user);
            },
          ),

          // New Chat Button
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<ChatCubit>().startNewChat();
                context.read<ChatHistoryCubit>().loadSessions();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.add),
              label: Text(AppTitle.newChat.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColor.buttonWelcome,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Body - Chat History
          Expanded(
            child: BlocBuilder<ChatHistoryCubit, ChatHistoryState>(
              builder: (context, state) {
                if (state is ChatHistoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatHistoryLoaded) {
                  if (state.sessions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppTitle.noChatHistory.tr(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppTitle.newConversation.tr(),
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.sessions.length,
                    itemBuilder: (context, index) {
                      final session = state.sessions[index];
                      final isSelected = session.id == state.currentSessionId;

                      return SessionItem(
                        session: session,
                        isSelected: isSelected,
                        onTap: () async {
                          context.read<ChatHistoryCubit>().selectSession(session.id);
                          await context.read<ChatCubit>().loadSessionMessages(session.id);
                          // Navigator.pop(context);
                        },
                        onRename: (newTitle) {
                          context.read<ChatHistoryCubit>().updateTitle(session.id, newTitle);
                        },
                        onDelete: () {
                          context.read<ChatHistoryCubit>().deleteSession(session.id);
                          if (isSelected) {
                            context.read<ChatCubit>().startNewChat();
                          }
                        },
                      );
                    },
                  );
                } else if (state is ChatHistoryError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        Text(
                          AppTitle.errorLoadingHistory.tr(),
                          style: TextStyle(color: Colors.red[700]),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            state.message,
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          // Footer - Settings
          const DrawerFooter(),
        ],
      ),
    );
  }
}