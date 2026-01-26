import 'package:client/auth_service.dart';
import 'package:client/features/history/domain/usecases/clear_history.dart';
import 'package:client/features/history/domain/usecases/delete_history.dart';
import 'package:client/features/history/domain/usecases/record_read_history.dart';
import 'package:client/features/notification_settings/data/datasources/notification_settings_remote_datasource.dart';
import 'package:client/features/notification_settings/data/repositories/notification_settings_repository_impl.dart';
import 'package:client/features/notification_settings/domain/usecases/get_notification_settings.dart';
import 'package:client/features/notification_settings/domain/usecases/update_notification_settings.dart';
import 'package:client/features/profile/presentation/bloc/profile_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/gen_l10n/app_localizations.dart';
import 'package:client/features/login/presentation/pages/login_screen.dart';

import '../../../../core/layout/app_scaffold.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/theme_bloc.dart';
import '../../../../core/theme/theme_event.dart';
import '../../../../core/theme/theme_state.dart';

import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

import '../../../history/presentation/pages/history_page.dart';
import '../../../history/presentation/bloc/history_bloc.dart';
import '../../../history/presentation/bloc/history_event.dart';
import '../../../history/domain/usecases/get_reading_history.dart';
import '../../../history/data/datasources/history_remote_datasource.dart';
import '../../../history/data/repositories/history_repository_impl.dart';

import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/pages/personal_info_page.dart';

import 'language_page.dart';
import 'help_page.dart';
import 'privacy_policy_page.dart';
import 'terms_page.dart';
import 'about_page.dart';

import '../../../notification_settings/presentation/pages/notification_settings_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isMobile = Responsive.isMobile(context);

    return BlocProvider(
      create: (_) => SettingsBloc(context.read<AuthService>()),
      child: isMobile
          ? Scaffold(
              appBar: AppBar(title: Text(l10n.settings), centerTitle: true),
              body: const SettingsContent(),
            )
          : AppScaffold(
              currentIndex: 3,
              appBar: AppBar(title: Text(l10n.settings), centerTitle: false),
              body: const SettingsContent(),
            ),
    );
  }
}

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isDesktop ? 1200 : 800),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop
                ? 48
                : isTablet
                ? 32
                : 16,
            vertical: 16,
          ),
          child: isDesktop
              ? const _DesktopLayout()
              : const _MobileTabletLayout(),
        ),
      ),
    );
  }
}

class _MobileTabletLayout extends StatelessWidget {
  const _MobileTabletLayout();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: const [
              _AccountSection(),
              _GeneralSection(),
              _LensNewsSection(),
              SizedBox(height: 12),
              _LogoutSection(),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: _AppVersion(),
        ),
      ],
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: const [_AccountSection(), _GeneralSection()],
                ),
              ),
              const SizedBox(width: 32),

              Expanded(
                child: ListView(
                  children: const [
                    _LensNewsSection(),
                    SizedBox(height: 12),
                    _LogoutSection(),
                  ],
                ),
              ),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: _AppVersion(),
        ),
      ],
    );
  }
}

class _AccountSection extends StatelessWidget {
  const _AccountSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return _section(
      title: 'Akun',
      children: [
        _navTile(
          context,
          icon: Icons.person,
          title: l10n.personalInfo,
          page: const PersonalInfoPage(),
        ),
      ],
    );
  }
}

class _GeneralSection extends StatelessWidget {
  const _GeneralSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return _section(
      title: 'General',
      children: [
        ListTile(
          leading: const Icon(Icons.notifications),
          title: Text(l10n.notifications),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _openNotificationSettings(context),
        ),

        ListTile(
          leading: const Icon(Icons.history),
          title: Text(l10n.readingHistory),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _openHistory(context),
        ),
        _navTile(
          context,
          icon: Icons.language,
          title: l10n.changeLanguage,
          page: const LanguagePage(),
        ),
        _darkModeSwitch(context),
      ],
    );
  }
}

class _LensNewsSection extends StatelessWidget {
  const _LensNewsSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return _section(
      title: 'Lens News',
      children: [
        _navTile(
          context,
          icon: Icons.help_outline,
          title: l10n.help,
          page: const HelpPage(),
        ),
        _navTile(
          context,
          icon: Icons.privacy_tip,
          title: l10n.privacyPolicy,
          page: const PrivacyPolicyPage(),
        ),
        _navTile(
          context,
          icon: Icons.description,
          title: l10n.terms,
          page: const TermsPage(),
        ),
        _navTile(
          context,
          icon: Icons.info,
          title: l10n.about,
          page: const AboutPage(),
        ),
      ],
    );
  }
}

class _LogoutSection extends StatelessWidget {
  const _LogoutSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsLoggedOut) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (_) => false,
          );
        }

        if (state is SettingsError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: Text(l10n.logout),
          onTap: () => _showLogoutDialog(context),
        ),
      ),
    );
  }
}

class _AppVersion extends StatelessWidget {
  const _AppVersion();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context).appVersion('1.1'),
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}

void _openNotificationSettings(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (_) => NotificationSettingsRemoteDataSource(DioClient.dio),
          ),
          RepositoryProvider(
            create: (ctx) => NotificationSettingsRepositoryImpl(
              ctx.read<NotificationSettingsRemoteDataSource>(),
            ),
          ),
          RepositoryProvider(
            create: (ctx) => GetNotificationSettings(
              ctx.read<NotificationSettingsRepositoryImpl>(),
            ),
          ),
          RepositoryProvider(
            create: (ctx) => UpdateNotificationSettings(
              ctx.read<NotificationSettingsRepositoryImpl>(),
            ),
          ),
        ],
        child: const NotificationSettingsPage(),
      ),
    ),
  );
}

void _openHistory(BuildContext context) {
  final remote = HistoryRemoteDataSourceImpl(DioClient.dio);
  final repository = HistoryRepositoryImpl(remote);

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => HistoryBloc(
          getHistory: GetReadingHistory(repository),
          deleteHistory: DeleteHistory(repository),
          clearHistory: ClearHistory(repository),
          recordReadHistory: RecordReadHistory(repository),
        )..add(LoadHistory()),
        child: const HistoryPage(),
      ),
    ),
  );
}

Widget _section({required String title, required List<Widget> children}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 16),
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(children: children),
      ),
    ],
  );
}

Widget _navTile(
  BuildContext context, {
  required IconData icon,
  required String title,
  required Widget page,
}) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    trailing: const Icon(Icons.chevron_right),
    onTap: () async {
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<ProfileBloc>(),
            child: page,
          ),
        ),
      );

      if (result == true) {
        context.read<ProfileBloc>().add(LoadProfile());
      }
    },
  );
}

Widget _darkModeSwitch(BuildContext context) {
  final l10n = AppLocalizations.of(context);

  return BlocBuilder<ThemeBloc, ThemeState>(
    builder: (context, state) {
      final brightness = MediaQuery.of(context).platformBrightness;

      final isDark =
          state.themeMode == ThemeMode.dark ||
          (state.themeMode == ThemeMode.system &&
              brightness == Brightness.dark);

      return SwitchListTile(
        secondary: const Icon(Icons.dark_mode),
        title: Text(l10n.darkMode),
        value: isDark,
        onChanged: (value) {
          context.read<ThemeBloc>().add(ToggleTheme(value));
        },
      );
    },
  );
}

void _showLogoutDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(l10n.logout),
      content: Text(l10n.logoutConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<SettingsBloc>().add(LogoutRequested());
            Navigator.pop(context);
          },
          child: Text(l10n.logout),
        ),
      ],
    ),
  );
}
