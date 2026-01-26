import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/layout/app_scaffold.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/localization/language_bloc.dart';
import '../../../../core/localization/language_event.dart';
import '../../../../core/localization/language_state.dart';
import '../../../../gen_l10n/app_localizations.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);

    final content = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isDesktop
              ? 1100
              : isTablet
              ? 900
              : double.infinity,
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop
                ? 64
                : isTablet
                ? 32
                : 16,
            vertical: 24,
          ),
          children: [
            BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, state) {
                final currentCode =
                    state.locale?.languageCode ??
                    Localizations.localeOf(context).languageCode;

                return RadioGroup<String>(
                  groupValue: currentCode,
                  onChanged: (value) {
                    if (value == null) return;
                    context.read<LanguageBloc>().add(
                      ChangeLanguage(Locale(value)),
                    );
                  },
                  child: Column(
                    children: const [
                      RadioListTile<String>(
                        value: 'id',
                        title: Text('Bahasa Indonesia'),
                      ),
                      Divider(height: 1),
                      RadioListTile<String>(
                        value: 'en',
                        title: Text('English'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.changeLanguage), centerTitle: true),
        body: content,
      );
    }

    return AppScaffold(
      currentIndex: 3,
      appBar: AppBar(title: Text(l10n.changeLanguage), centerTitle: false),
      body: content,
    );
  }
}
