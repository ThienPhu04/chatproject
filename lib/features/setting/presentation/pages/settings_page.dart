import 'package:easy_localization/easy_localization.dart';
import 'package:finalproject/core/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTitle.settings.tr()),
        elevation: 1,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          String currentLanguage = 'en';
          bool isDarkMode = false;

          if (state is SettingsLoaded) {
            currentLanguage = state.settings.language;
            isDarkMode = state.settings.isDarkMode;
          }

          return ListView(
            children: [
              // Language Section
              ListTile(
                leading: const Icon(Icons.language, color: Colors.blue),
                title: Text(AppTitle.language.tr()),
                subtitle: Text(_getLanguageName(currentLanguage)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showLanguageDialog(context, currentLanguage),
              ),

              // Appearance Section
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode, color: Colors.blue),
                title: Text(AppTitle.darkMode.tr()),
                subtitle: Text(AppTitle.enableDarkTheme.tr()),
                value: isDarkMode,
                onChanged: (value) {
                  context.read<SettingsCubit>().changeTheme(value);
                },
              ),
              // Account Section
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  final isLoggedIn = authState is AuthSuccess;

                  return ListTile(
                    leading: Icon(
                      isLoggedIn ? Icons.logout : Icons.login,
                      color: isLoggedIn ? Colors.red : Colors.blue,
                    ),
                    title: Text(isLoggedIn ? AppTitle.logout.tr() : AppTitle.login.tr()),
                    onTap: () {
                      if (isLoggedIn) {
                        _showLogoutConfirmation(context);
                      } else {
                        context.go("/login");
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'vi':
        return 'Tiếng Việt';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'zh':
        return '中文';
      default:
        return 'English';
    }
  }

  void _showLanguageDialog(BuildContext context, String currentLanguage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppTitle.selectLanguage.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(
                context,
                'en',
                'English',
                currentLanguage,
              ),
              _buildLanguageOption(
                context,
                'vi',
                'Tiếng Việt',
                currentLanguage,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
      BuildContext context,
      String code,
      String name,
      String currentLanguage,
      ) {
    final isSelected = code == currentLanguage;
    return RadioListTile<String>(
      title: Text(name),
      value: code,
      groupValue: currentLanguage,
      selected: isSelected,
      onChanged: (value) async{
        if (value != null) {
          context.read<SettingsCubit>().changeLanguage(value);
          final locale = Locale(value);
          await context.setLocale(locale);
          Navigator.pop(context);
        }
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppTitle.logout.tr()),
          content: Text(AppTitle.youWantLogout.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppTitle.cancel.tr()),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthCubit>().logout();
                Navigator.pop(context);
              },
              child: Text(
                AppTitle.logout.tr(),
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}