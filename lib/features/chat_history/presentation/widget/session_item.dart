import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/core/constant/constant.dart';
import '../../domain/entities/chat_session.dart';

class SessionItem extends StatelessWidget {
  final ChatSession session;
  final bool isSelected;
  final VoidCallback onTap;
  final Function(String) onRename;
  final VoidCallback onDelete;

  const SessionItem({
    super.key,
    required this.session,
    required this.isSelected,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isSelected
        ? theme.colorScheme.secondaryContainer.withOpacity(isDark ? 0.4 : 0.6)
        : Colors.transparent;
    final titleColor = isSelected
        ? theme.colorScheme.onSecondaryContainer
        : theme.textTheme.bodyMedium?.color ?? Colors.black;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          session.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: titleColor,
          ),
        ),
        onTap: onTap,
        onLongPress: () => _showOptions(context, theme),
      ),
    );
  }

  void _showOptions(BuildContext context, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    final sheetColor = isDark
        ? theme.colorScheme.surfaceVariant.withOpacity(0.95)
        : theme.colorScheme.surface;

    final iconColor = theme.iconTheme.color;
    final textColor = theme.textTheme.bodyMedium?.color;

    showModalBottomSheet(
      context: context,
      backgroundColor: sheetColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.edit, color: iconColor),
                title: Text(AppTitle.rename.tr(),
                    style: TextStyle(color: textColor)),
                onTap: () {
                  Navigator.pop(context);
                  _showRenameDialog(context, theme);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: theme.colorScheme.error),
                title: Text(
                  AppTitle.delete.tr(),
                  style: TextStyle(color: theme.colorScheme.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, theme);
                },
              ),
              ListTile(
                leading: Icon(Icons.close, color: iconColor),
                title: Text(AppTitle.cancel.tr(),
                    style: TextStyle(color: textColor)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRenameDialog(BuildContext context, ThemeData theme) {
    final controller = TextEditingController(text: session.title);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = theme.colorScheme.surface;
    final textColor = theme.textTheme.bodyMedium?.color;
    final hintColor = theme.hintColor;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(AppTitle.renameChat.tr(),
              style: TextStyle(color: textColor)),
          content: TextField(
            controller: controller,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: AppTitle.enterNewTitle.tr(),
              hintStyle: TextStyle(color: hintColor),
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: isDark
                        ? theme.colorScheme.outline
                        : theme.colorScheme.primary.withOpacity(0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.colorScheme.primary),
              ),
            ),
            autofocus: true,
            maxLength: 50,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppTitle.cancel.tr(),
                  style: TextStyle(color: theme.colorScheme.primary)),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  onRename(controller.text.trim());
                  Navigator.pop(context);
                }
              },
              child: Text(AppTitle.save.tr(),
                  style: TextStyle(color: theme.colorScheme.primary)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, ThemeData theme) {
    final textColor = theme.textTheme.bodyMedium?.color;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          title: Text(AppTitle.deleteChat.tr(),
              style: TextStyle(color: textColor)),
          content: Text(
            '${AppTitle.confrimDelete.tr()} ${session.title}?',
            style: TextStyle(color: textColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppTitle.cancel.tr(),
                  style: TextStyle(color: theme.colorScheme.primary)),
            ),
            TextButton(
              onPressed: () {
                onDelete();
                Navigator.pop(context);
              },
              style:
              TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
              child: Text(AppTitle.delete.tr()),
            ),
          ],
        );
      },
    );
  }
}
