import 'package:flutter/material.dart';
import 'app_export.dart';
import 'features/chat_history/domain/usecase/save_message.dart' as history;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive Adapters
  Hive.registerAdapter(MessageStatusHiveAdapter());
  Hive.registerAdapter(MessageModelAdapter());
  Hive.registerAdapter(ChatSessionModelAdapter());

  final ttsService = TtsService();
  await ttsService.initialize();

  final fcmService = FCMService();
  await fcmService.initialize();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");

  const flavor = String.fromEnvironment('flavor', defaultValue: 'prod');
  switch (flavor) {
    case 'dev':
      FlavorConfig.appFlavor = Flavor.dev;
      break;
    case 'staging':
      FlavorConfig.appFlavor = Flavor.staging;
      break;
    case 'production':
    default:
      FlavorConfig.appFlavor = Flavor.prod;
      break;
  }

  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(
    prefs: prefs,
    ttsService: ttsService,
  ));

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final TtsService ttsService;
  const MyApp({super.key, required this.prefs, required this.ttsService});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [Locale('vi'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('vi'),
      child: _AppContent(prefs: prefs, ttsService: ttsService),
    );
  }
}

class _AppContent extends StatelessWidget {
  final SharedPreferences prefs;
  final TtsService ttsService;
  const _AppContent({required this.prefs, required this.ttsService});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo dependency cho Onboarding
    final onboardingLocalDataSource = OnboardingLocalDataSourceImpl();
    final onboardingRepository =
        OnboardingRepositoryImpl(onboardingLocalDataSource);
    final checkFirstLaunch = CheckFirstLaunch(onboardingRepository);
    final completeOnboarding = CompleteOnboarding(onboardingRepository);

    // Khởi tạo dependency cho Chat
    final chatRemoteDataSource = ChatRemoteDataSourceImpl();
    final suggestionLocalDataSource = SuggestionLocalDataSource();
    final chatRepository = ChatRepositoryImpl(
      remoteDataSource: chatRemoteDataSource,
      suggestionDataSource: suggestionLocalDataSource,
    );
    final sendMessageUseCase = SendMessage(chatRepository);
    final getSuggestionsUseCase = GetSuggestions(chatRepository);

    // CHAT HISTORY DEPENDENCIES
    final chatHistoryLocalDataSource = ChatHistoryLocalDataSourceImpl();
    final chatHistoryRemoteDataSource = ChatHistoryRemoteDataSourceImpl();
    final chatHistoryRepository = ChatHistoryRepositoryImpl(
      localDataSource: chatHistoryLocalDataSource,
      remoteDataSource: chatHistoryRemoteDataSource,
      auth: FirebaseAuth.instance,
      prefs: prefs,
    );
    final getAllSessionsUseCase = GetAllSessions(chatHistoryRepository);
    final createSessionUseCase = CreateSession(chatHistoryRepository);
    final updateSessionTitleUseCase = UpdateSessionTitle(chatHistoryRepository);
    final deleteSessionUseCase = DeleteSession(chatHistoryRepository);
    final saveMessageUseCase = history.SaveMessage(chatHistoryRepository);
    final getSessionMessagesUseCase = GetSessionMessages(chatHistoryRepository);

    // Khởi tạo dependency cho Auth
    final authRemoteDataSource = AuthRemoteDataSourceImpl();
    final authRepository = AuthRepositoryImpl(authRemoteDataSource);

    // Khởi tạo Use Cases
    final loginWithEmailUseCase = LoginWithEmail(authRepository);
    final registerWithEmailUseCase = RegisterWithEmail(authRepository);
    final loginWithGoogleUseCase = LoginWithGoogle(authRepository);
    final loginWithFacebookUseCase = LoginWithFacebook(authRepository);
    final loginWithAppleUseCase = LoginWithApple(authRepository);
    final logoutUseCase = Logout(authRepository);
    final getCurrentUserUseCase = GetCurrentUser(authRepository);

    // Khởi tạo dependency cho Settings
    final settingsLocalDataSource = SettingsLocalDataSourceImpl(prefs);
    final settingsRepository = SettingsRepositoryImpl(settingsLocalDataSource);
    final getSettingsUseCase = GetSettings(settingsRepository);
    final saveLanguageUseCase = ChangeLanguage(settingsRepository);
    final saveThemeUseCase = ChangeTheme(settingsRepository);

    // Khởi tạo dependency cho Share
    final shareDataSource = ShareDataSource(scheme: 'final');
    final shareRepository = ShareRepositoryImpl(dataSource: shareDataSource);
    // final generateShareLinkUseCase = GenerateShareLink(shareRepository);
    // final shareChatUseCase = ShareChat(shareRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TtsCubit(ttsService)..initialize(),
        ),
        BlocProvider(
          create: (_) => OnboardingCubit(
            checkFirstLaunch: checkFirstLaunch,
            completeOnboarding: completeOnboarding,
          )..loadOnboarding(),
        ),
        BlocProvider(
          create: (_) => ChatCubit(
            sendMessageUseCase: sendMessageUseCase,
            getSuggestionsUseCase: getSuggestionsUseCase,
            saveMessageUseCase: saveMessageUseCase,
            historyRepository: chatHistoryRepository,
          ),
        ),
        BlocProvider(
          create: (_) => ChatHistoryCubit(
            getAllSessionsUseCase: getAllSessionsUseCase,
            createSessionUseCase: createSessionUseCase,
            updateSessionTitleUseCase: updateSessionTitleUseCase,
            deleteSessionUseCase: deleteSessionUseCase,
            getSessionMessagesUseCase: getSessionMessagesUseCase,
          ),
        ),
        BlocProvider(
          create: (_) => ShareCubit(repository: shareRepository),
        ),
        BlocProvider(
          create: (_) => AuthCubit(
            loginWithEmailUseCase: loginWithEmailUseCase,
            registerWithEmailUseCase: registerWithEmailUseCase,
            loginWithGoogleUseCase: loginWithGoogleUseCase,
            loginWithFacebookUseCase: loginWithFacebookUseCase,
            loginWithAppleUseCase: loginWithAppleUseCase,
            logoutUseCase: logoutUseCase,
            getCurrentUserUseCase: getCurrentUserUseCase,
          )..checkAuthStatus(),
        ),
        BlocProvider(
          create: (_) => SettingsCubit(
            getSettingsUseCase: getSettingsUseCase,
            saveLanguageUseCase: saveLanguageUseCase,
            saveThemeUseCase: saveThemeUseCase,
          ),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          bool isDarkMode = false;
          if (state is SettingsLoaded) {
            isDarkMode = state.settings.isDarkMode;
          }
          return MaterialApp.router(
            routerConfig: appRouter,
            debugShowCheckedModeBanner: false,
            title: 'AI Chat Bot Title',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          );
        },
      ),
    );
  }
}
