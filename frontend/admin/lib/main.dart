import 'package:admin/core/layout/admin_layout.dart';

// ================= Admin Logs
import 'package:admin/features/admin_log/data/datasources/admin_log_remote_datasource.dart';
import 'package:admin/features/admin_log/data/repositories/admin_log_repository_impl.dart';
import 'package:admin/features/admin_log/domain/usecases/get_admin_logs.dart';
import 'package:admin/features/admin_log/presentation/bloc/admin_log_bloc.dart';
import 'package:admin/features/admin_log/presentation/pages/admin_log_page.dart';
import 'package:admin/features/ai_summary/presentation/pages/ai_summary_detail_page.dart';
import 'package:admin/features/ai_summary/presentation/pages/ai_summary_page.dart';
import 'package:admin/features/news/data/datasources/ai_summary_status_remote_datasource.dart';

import 'package:admin/features/news/domain/usecases/get_news_by_id.dart';
import 'package:admin/features/news/presentation/bloc/ai_summary_status_bloc.dart';
import 'package:admin/features/news/presentation/bloc/ai_summary_status_event.dart';
import 'package:admin/features/publisher/presentation/bloc/publisher_event.dart';
import 'package:admin/features/users/presentation/bloc/users_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

// ================= AUTH =================
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_admin.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';

// ================= DASHBOARD =================
import 'features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/dashboard/domain/usecases/get_dashboard_data.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';

// ================= NEWS =================
import 'features/news/data/datasources/news_remote_data_source.dart';
import 'features/news/data/repositories/news_repository_impl.dart';
import 'features/news/domain/usecases/get_all_news.dart';
import 'features/news/domain/usecases/create_news.dart';
import 'features/news/domain/usecases/update_news.dart';
import 'features/news/domain/usecases/delete_news.dart';
import 'features/news/presentation/bloc/news_bloc.dart';
import 'features/news/presentation/pages/news_page.dart';

// ================= PUBLISHER =================
import 'features/publisher/data/datasources/publisher_remote_datasource.dart';
import 'features/publisher/data/repositories/publisher_repository_impl.dart';
import 'features/publisher/domain/usecases/get_publishers.dart';
import 'features/publisher/domain/usecases/create_publisher.dart';
import 'features/publisher/domain/usecases/update_publisher.dart';
import 'features/publisher/domain/usecases/delete_publisher.dart';
import 'features/publisher/presentation/bloc/publisher_bloc.dart';
import 'features/publisher/presentation/pages/publisher_page.dart';

// ================= CATEGORY =================
import 'features/category/data/datasources/category_remote_datasource.dart';
import 'features/category/data/repositories/category_repository_impl.dart';
import 'features/category/domain/usecases/get_categories.dart';
import 'features/category/domain/usecases/create_category.dart';
import 'features/category/domain/usecases/update_category.dart';
import 'features/category/domain/usecases/delete_category.dart';
import 'features/category/presentation/bloc/category_bloc.dart';
import 'features/category/presentation/pages/category_page.dart';

// ================= REPORT =================
import 'features/report/data/datasources/report_remote_datasource.dart';
import 'features/report/data/repositories/report_repository_impl.dart';
import 'features/report/domain/usecases/get_reports.dart';
import 'features/report/domain/usecases/update_report_status.dart';
import 'features/report/domain/usecases/delete_report.dart';
import 'features/report/presentation/bloc/report_bloc.dart';
import 'features/report/presentation/pages/report_page.dart';

// =============== ADMIN (CRUD) =================

import 'package:admin/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:admin/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:admin/features/admin/domain/usecases/create_admin.dart';
import 'package:admin/features/admin/presentation/bloc/admin_event.dart';
import 'package:admin/features/admin/domain/usecases/get_admins.dart';
import 'package:admin/features/admin/domain/usecases/update_admin.dart';
import 'package:admin/features/admin/domain/usecases/delete_admin.dart';

import 'package:admin/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:admin/features/admin/presentation/pages/admin_list_page.dart';
import 'package:admin/features/admin/presentation/pages/admin_create_page.dart';
import 'package:admin/features/admin/presentation/pages/admin_edit_page.dart';

// ================= USERS =================
import 'features/users/data/datasources/user_remote_datasource.dart';
import 'features/users/data/repositories/user_repository_impl.dart';
import 'features/users/domain/usecases/get_users.dart';
import 'features/users/domain/usecases/toggle_user_status.dart';
import 'features/users/presentation/bloc/users_bloc.dart';
import 'features/users/presentation/pages/user_list_page.dart';

//Ai
// ================= AI SUMMARY =================
import 'features/ai_summary/data/datasources/ai_summary_remote_datasource.dart';
import 'features/ai_summary/data/repositories/ai_summary_repository_impl.dart';
import 'features/ai_summary/domain/usecases/get_all_ai_summaries.dart';
import 'features/ai_summary/presentation/bloc/ai_summary_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final httpClient = http.Client();

  // ================= AUTH =================
  final authRemote = AuthRemoteDataSourceImpl(client: httpClient);
  final authRepo = AuthRepositoryImpl(remoteDataSource: authRemote);
  final loginAdmin = LoginAdmin(authRepo);

  // ================= DASHBOARD =================
  final dashboardRemote = DashboardRemoteDataSource(client: httpClient);
  final dashboardRepo = DashboardRepositoryImpl(remote: dashboardRemote);
  final getDashboardData = GetDashboardData(dashboardRepo);

  // ================= NEWS =================
  final newsRemote = NewsRemoteDataSource(httpClient);
  final newsRepo = NewsRepositoryImpl(newsRemote);

  final getAllNews = GetAllNews(newsRepo);
  final createNews = CreateNews(newsRepo);
  final updateNews = UpdateNews(newsRepo);
  final deleteNews = DeleteNews(newsRepo);
  final getNewsById = GetNewsById(newsRepo);

  // ================= PUBLISHER =================
  final publisherRemote = PublisherRemoteDataSource(httpClient);
  final publisherRepo = PublisherRepositoryImpl(publisherRemote);

  final getPublishers = GetPublishers(publisherRepo);
  final createPublisher = CreatePublisher(publisherRepo);
  final updatePublisher = UpdatePublisher(publisherRepo);
  final deletePublisher = DeletePublisher(publisherRepo);

  // ================= CATEGORY =================
  final categoryRemote = CategoryRemoteDataSource(httpClient);
  final categoryRepo = CategoryRepositoryImpl(categoryRemote);

  final getCategories = GetCategories(categoryRepo);
  final createCategory = CreateCategory(categoryRepo);
  final updateCategory = UpdateCategory(categoryRepo);
  final deleteCategory = DeleteCategory(categoryRepo);

  // ================= REPORT =================
  final reportRemote = ReportRemoteDataSource(httpClient);
  final reportRepo = ReportRepositoryImpl(reportRemote);

  final getReports = GetReports(reportRepo);
  final updateReportStatus = UpdateReportStatus(reportRepo);
  final deleteReport = DeleteReport(reportRepo);

  // ================= ADMIN LOG =================
  final adminLogRemote = AdminLogRemoteDataSource(httpClient);
  final adminLogRepo = AdminLogRepositoryImpl(adminLogRemote);

  final getAdminLogs = GetAdminLogs(adminLogRepo);

  // ================= Admin Management =================
  final adminRemote = AdminRemoteDataSource(httpClient);
  final adminRepo = AdminRepositoryImpl(adminRemote);
  final createAdmin = CreateAdmin(adminRepo);

  final getAdmins = GetAdmins(adminRepo);
  final updateAdmin = UpdateAdmin(adminRepo);
  final deleteAdmin = DeleteAdmin(adminRepo);

  // ================= USERS =================
  final userRemote = UserRemoteDataSource(httpClient);
  final userRepo = UserRepositoryImpl(userRemote);

  final getUsers = GetUsers(userRepo);
  final activateUser = ToggleUserStatus(userRepo);

  // Ai summary
  // ================= AI SUMMARY =================
  final aiSummaryRemote = AiSummaryRemoteDataSource(httpClient);
  final aiSummaryRepo = AiSummaryRepositoryImpl(aiSummaryRemote);

  final getAll = GetAllAiSummaries(aiSummaryRepo);

  final aiSummaryStatusRemote = AiSummaryStatusRemoteDataSource(httpClient);

  runApp(
    MultiBlocProvider(
      providers: [
        // AUTH
        BlocProvider(create: (_) => AuthBloc(loginAdmin: loginAdmin)),

        // DASHBOARD
        BlocProvider(create: (_) => DashboardBloc(getDashboardData)),

        // NEWS
        BlocProvider(
          create: (_) => NewsBloc(
            getAllNews: getAllNews,
            createNews: createNews,
            updateNews: updateNews,
            deleteNews: deleteNews,
            getNewsById: getNewsById,
          ),
        ),

        // PUBLISHER
        BlocProvider(
          create: (_) => PublisherBloc(
            getPublishers: getPublishers,
            createPublisher: createPublisher,
            updatePublisher: updatePublisher,
            deletePublisher: deletePublisher,
          )..add(LoadPublishers()),
        ),

        // CATEGORY
        BlocProvider(
          create: (_) => CategoryBloc(
            getCategories: getCategories,
            createCategory: createCategory,
            updateCategory: updateCategory,
            deleteCategory: deleteCategory,
          ),
        ),

        // REPORT
        BlocProvider(
          create: (_) => ReportBloc(
            getReports: getReports,
            updateStatus: updateReportStatus,
            deleteReport: deleteReport,
          ),
        ),
        BlocProvider(create: (_) => AdminLogBloc(getAdminLogs)),
        BlocProvider(
          create: (_) => AdminBloc(
            getAdmins: getAdmins,
            createAdmin: createAdmin,
            updateAdmin: updateAdmin,
            deleteAdmin: deleteAdmin,
          )..add(LoadAdmins()),
        ),
        // USERS
        BlocProvider(
          create: (_) =>
              UserBloc(getUsers: getUsers, toggleUserStatus: activateUser)
                ..add(const LoadUsersEvent()),
        ),
        BlocProvider(create: (_) => AiSummaryBloc(getAll)),
        BlocProvider(
          create: (_) =>
              AiSummaryStatusBloc(aiSummaryStatusRemote)
                ..add(LoadAiSummaryStatus()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// =================================================
// APP ROOT
// =================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart News Admin',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2E5C48),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/dashboard': (_) => const AdminLayout(child: DashboardPage()),
        '/news': (_) => const NewsPage(),
        '/category': (_) => const AdminLayout(child: CategoryPage()),
        '/publisher': (_) => const AdminLayout(child: PublisherPage()),
        '/report': (_) => const ReportPage(),
        '/logs': (_) => const AdminLogPage(),
        '/admin': (_) => const AdminListPage(),
        '/admin/create': (_) => const AdminCreatePage(),
        '/admin/edit': (_) => const AdminEditPage(),
        '/users': (_) => const UserListPage(),
        '/ai-summary': (_) => const AdminLayout(child: AiSummaryPage()),
        '/ai-summary/detail': (_) =>
            const AdminLayout(child: AiSummaryDetailPage()),
      },
    );
  }
}
