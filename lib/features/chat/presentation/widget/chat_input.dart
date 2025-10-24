import 'package:easy_localization/easy_localization.dart';
import 'package:finalproject/core/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../gen/assets.gen.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<ChatCubit>().sendMessage(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor =
    isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final fieldColor = isDark
        ? AppColors.darkInputBackground
        : AppColors.lightInputBackground;
    final hintColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final iconColor =
    isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;

    final textColor =
    isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.6)
                : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: AppTitle.typeMessage.tr(),
                  hintStyle: TextStyle(color: hintColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: fieldColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(context),
              ),
            ),
            const SizedBox(width: 8),
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                final isLoading = state is ChatLoading;
                return IconButton(
                  icon: isLoading
                      ? SizedBox(
                    width: 24,
                    height: 24,
                    child: Assets.icons.send.image()
                  )
                      : ImageIcon(
                    AssetImage(Assets.icons.send.path),
                    color: iconColor,
                    size: 24,
                  ),
                  onPressed: isLoading ? null : () => _sendMessage(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
