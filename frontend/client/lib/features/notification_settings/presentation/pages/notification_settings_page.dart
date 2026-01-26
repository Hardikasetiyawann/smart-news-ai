import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/gen_l10n/app_localizations.dart';

import '../../../../core/layout/app_scaffold.dart';
import '../../../../core/responsive/responsive.dart';

import '../../domain/usecases/get_notification_settings.dart';
import '../../domain/usecases/update_notification_settings.dart';

import '../bloc/notification_settings_bloc.dart';
import '../bloc/notification_settings_event.dart';
import '../bloc/notification_settings_state.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isMobile = Responsive.isMobile(context);

    final content = BlocProvider(
      create: (_) => NotificationSettingsBloc(
        getSettings: context.read<GetNotificationSettings>(),
        updateSettings: context.read<UpdateNotificationSettings>(),
      )..add(LoadNotificationSettings()),
      child: BlocBuilder<NotificationSettingsBloc, NotificationSettingsState>(
        builder: (context, state) {
          if (state is NotificationSettingsLoading ||
              state is NotificationSettingsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationSettingsError) {
            return Center(
              child: Text(
                l10n.notificationSettingsError,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is NotificationSettingsLoaded) {
            return _SettingsContent(state: state);
          }

          return const SizedBox.shrink();
        },
      ),
    );

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.notificationSettings),
          centerTitle: true,
        ),
        body: content,
      );
    }

    return AppScaffold(
      currentIndex: 3,
      appBar: AppBar(
        title: Text(l10n.notificationSettings),
        centerTitle: false,
      ),
      body: content,
    );
  }
}

class _SettingsContent extends StatelessWidget {
  final NotificationSettingsLoaded state;

  const _SettingsContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isDesktop
              ? 900
              : isTablet
                  ? 700
                  : double.infinity,
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop
                ? 48
                : isTablet
                    ? 32
                    : 16,
            vertical: 16,
          ),
          children: [
            _section(
              children: [
                SwitchListTile(
                  title: Text(l10n.notificationNewsTitle),
                  subtitle: Text(l10n.notificationNewsSubtitle),
                  value: state.news,
                  onChanged: (value) {
                    context.read<NotificationSettingsBloc>().add(
                      UpdateNotificationSettingsEvent(news: value),
                    );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Text(l10n.notificationSilentTitle),
                  subtitle: Text(l10n.notificationSilentSubtitle),
                  value: state.silent,
                  onChanged: (value) {
                    context.read<NotificationSettingsBloc>().add(
                      UpdateNotificationSettingsEvent(silent: value),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _section({
  required List<Widget> children,
}) {
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(children: children),
  );
}
