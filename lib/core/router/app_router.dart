import 'package:finalproject/core/router/share_handler.dart';
import 'package:finalproject/features/auth/presentation/pages/register_page.dart';
import 'package:finalproject/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:finalproject/features/share/data/repositories/share_repository_impl.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/setting/presentation/pages/settings_page.dart';
import '../../features/share/data/datasources/share_datasource.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/chat',
      name: 'chat',
      builder: (context, state) {
        final sessionId = state.uri.queryParameters['sessionId'];
        return ChatPage(initialSessionId: sessionId);
      },
    ),
    GoRoute(
      path: '/welcome',
      name: 'welcome',
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/logout',
      name: 'logout',
      builder: (context, state) => ChatPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/share',
      name: 'share',
      builder: (context, state) {
        final encodedData = state.uri.queryParameters['data'];

        print('Dữ liệu được mã hóa từ liên kết chia sẻ: $encodedData');

        if (encodedData != null && encodedData.isNotEmpty) {
          return SharedChatHandler(
            encodedData: encodedData,
            shareRepository: ShareRepositoryImpl(
              dataSource: ShareDataSource(scheme: 'final'),
            ),
          );
        }
        return const InvalidShareLinkPage();
      },
    ),
  ],
  debugLogDiagnostics: true,
);

