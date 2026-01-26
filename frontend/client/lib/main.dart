import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'core/network/dio_client.dart';

// ================= CORE =================
import 'core/theme/theme_bloc.dart';
import 'core/theme/theme_event.dart';
import 'core/theme/theme_state.dart';
import 'core/theme/app_theme.dart';

import 'core/localization/language_bloc.dart';
import 'core/localization/language_event.dart';
import 'core/localization/language_state.dart';
import 'gen_l10n/app_localizations.dart';

import 'core/services/firebase_notification_service.dart';

// ================= AUTH =================
import 'auth_service.dart';

// ================= DASHBOARD =================
import 'features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/dashboard/domain/usecases/get_trending_news.dart';
import 'features/dashboard/domain/usecases/get_latest_news.dart';
import 'features/dashboard/domain/usecases/get_categories.dart';
import 'features/dashboard/domain/usecases/get_publishers.dart';
import 'features/dashboard/domain/usecases/get_news_by_category.dart';
import 'features/dashboard/domain/usecases/get_current_user.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';

// ================= SEARCH =================
import 'features/search/data/datasources/search_remote_data_source.dart';
import 'features/search/data/repositories/search_repository_impl.dart';
import 'features/search/domain/usecases/search_news.dart';
import 'features/search/presentation/bloc/search_bloc.dart';

// ================= BOOKMARK =================
import 'features/bookmark/data/datasources/bookmark_local_datasource.dart';
import 'features/bookmark/data/repositories/bookmark_repository_impl.dart';
import 'features/bookmark/domain/usecases/add_bookmark.dart';
import 'features/bookmark/domain/usecases/remove_bookmark.dart';
import 'features/bookmark/domain/usecases/get_bookmarks.dart';
import 'features/bookmark/domain/usecases/is_bookmarked.dart';
import 'features/bookmark/domain/usecases/clear_bookmarks.dart';
import 'features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'features/bookmark/presentation/pages/bookmark_page.dart';

// ================= PROFILE =================
import 'features/profile/data/datasources/profile_remote_datasource.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/usecases/get_profile_usecase.dart';
import 'features/profile/domain/usecases/get_liked_news_usecase.dart';
import 'features/profile/domain/usecases/update_profile_usecase.dart';
import 'features/profile/domain/usecases/unlike_news_usecase.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/profile/presentation/bloc/profile_event.dart';

// ================= NOTIFICATION =================
import 'features/notification/data/datasources/notification_remote_datasource.dart';
import 'features/notification/data/repositories/notification_repository_impl.dart';
import 'features/notification/domain/usecases/get_notification.dart';
import 'features/notification/domain/usecases/mark_notification_read.dart';
import 'features/notification/domain/usecases/delete_notification.dart';
import 'features/notification/presentation/bloc/notification_bloc.dart';
import 'features/notification/presentation/bloc/notification_event.dart';

// ================= REPORT =================
import 'features/reports/data/datasources/report_remote_datasource.dart';
import 'features/reports/data/repositories/report_repository_impl.dart';
import 'features/reports/domain/usecases/create_report.dart';

// ================= PAGES =================
import 'features/login/presentation/pages/splash_screen.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/search/presentation/pages/search_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/notification/presentation/pages/notification_page.dart';

/// =======================================================
/// 🔥 ENTRY POINT
/// =======================================================
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔐 JWT READY SEBELUM APP JALAN
  final authService = AuthService();
  await authService.getJwt();

  // ================= REMOTE DATASOURCES =================
  final dashboardRemote = DashboardRemoteDataSource(DioClient.dio);
  final searchRemote = SearchRemoteDataSourceImpl(DioClient.dio);
  final profileRemote = ProfileRemoteDataSourceImpl(DioClient.dio);
  final notificationRemote = NotificationRemoteDataSourceImpl(DioClient.dio);

  // ================= REPOSITORIES =================
  final dashboardRepository = DashboardRepositoryImpl(dashboardRemote);
  final searchRepository = SearchRepositoryImpl(searchRemote);
  final profileRepository = ProfileRepositoryImpl(profileRemote);
  final notificationRepository = NotificationRepositoryImpl(notificationRemote);

  // ================= BOOKMARK LOCAL =================
  final bookmarkLocal = BookmarkLocalDataSourceImpl();
  final bookmarkRepository = BookmarkRepositoryImpl(bookmarkLocal);

  runApp(
    RepositoryProvider<AuthService>.value(
      value: authService,
      child: MyApp(
        dashboardRepository: dashboardRepository,
        searchRepository: searchRepository,
        bookmarkRepository: bookmarkRepository,
        profileRepository: profileRepository,
        notificationRepository: notificationRepository,
      ),
    ),
  );
}

/// =======================================================
/// 🔥 ROOT APP
/// =======================================================
class MyApp extends StatelessWidget {
  final DashboardRepositoryImpl dashboardRepository;
  final SearchRepositoryImpl searchRepository;
  final BookmarkRepositoryImpl bookmarkRepository;
  final ProfileRepositoryImpl profileRepository;
  final NotificationRepositoryImpl notificationRepository;

  const MyApp({
    super.key,
    required this.dashboardRepository,
    required this.searchRepository,
    required this.bookmarkRepository,
    required this.profileRepository,
    required this.notificationRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => GetProfileUseCase(profileRepository)),
        RepositoryProvider(
          create: (_) => GetLikedNewsUseCase(profileRepository),
        ),
        RepositoryProvider(
          create: (_) => UpdateProfileUseCase(profileRepository),
        ),

        RepositoryProvider(create: (_) => UnlikeNewsUseCase(profileRepository)),
        RepositoryProvider(create: (_) => SearchNewsUseCase(searchRepository)),
        RepositoryProvider(
          create: (_) => CreateReport(
            ReportRepositoryImpl(remoteDataSource: ReportRemoteDataSource()),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeBloc()..add(LoadTheme())),
          BlocProvider(create: (_) => LanguageBloc()..add(LoadLanguage())),
          BlocProvider(
            create: (_) => DashboardBloc(
              getTrendingNews: GetTrendingNews(dashboardRepository),
              getLatestNews: GetLatestNews(dashboardRepository),
              getCategories: GetCategories(dashboardRepository),
              getPublishers: GetPublishers(dashboardRepository),
              getNewsByCategory: GetNewsByCategory(dashboardRepository),
              getCurrentUser: GetCurrentUser(dashboardRepository),
            ),
          ),
          BlocProvider(
            create: (context) =>
                SearchNewsBloc(context.read<SearchNewsUseCase>()),
          ),
          BlocProvider(
            create: (_) => BookmarkBloc(
              addBookmark: AddBookmark(bookmarkRepository),
              removeBookmark: RemoveBookmark(bookmarkRepository),
              getBookmarks: GetBookmarks(bookmarkRepository),
              isBookmarked: IsBookmarked(bookmarkRepository),
              clearBookmarks: ClearBookmarks(bookmarkRepository),
            ),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(
              getProfile: context.read<GetProfileUseCase>(),
              getLikedNews: context.read<GetLikedNewsUseCase>(),
              updateProfile: context.read<UpdateProfileUseCase>(),
              unlikeNews: context.read<UnlikeNewsUseCase>(),
            )..add(LoadProfile()),
          ),
          BlocProvider(
            create: (_) => NotificationBloc(
              getNotifications: GetNotifications(notificationRepository),
              markNotificationRead: MarkNotificationRead(
                notificationRepository,
              ),
              deleteNotification: DeleteNotification(notificationRepository),
            ),
          ),
        ],
        child: const AppRoot(),
      ),
    );
  }
}

/// =======================================================
/// 🔥 APP ROOT + FCM INIT (BENAR)
/// =======================================================
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  final FirebaseNotificationService _firebaseService =
      FirebaseNotificationService();

  @override
  void initState() {
    super.initState();

    // 🔔 FCM INIT SETELAH JWT SIAP
    _firebaseService.init(
      onForeground: (_) {
        context.read<NotificationBloc>().add(
          const LoadNotifications(refresh: true),
        );
      },
      onTap: (_) {
        context.read<NotificationBloc>().add(
          const LoadNotifications(refresh: true),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, languageState) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'LensNews',

              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeState.themeMode,

              locale: languageState.locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,

              initialRoute: '/',
              routes: {
                '/': (_) => const SplashScreen(),
                '/dashboard': (_) => const DashboardPage(),
                '/search': (_) => const SearchPage(),
                '/bookmark': (_) => const BookmarkPage(),
                '/profile': (_) => const ProfilePage(),
                '/notifications': (_) => const NotificationPage(),
              },
            );
          },
        );
      },
    );
  }
}