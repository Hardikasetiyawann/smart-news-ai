import 'package:flutter/material.dart';
import 'package:client/gen_l10n/app_localizations.dart';

import '../../../../core/layout/app_scaffold.dart';
import '../../../../core/responsive/responsive.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

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
            Center(
              child: Column(
                children: [
                  Text(
                    l10n.termsHeader,
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.termsEffectiveDate,
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _paragraph(l10n.termsIntro),

            _sectionTitle(l10n.termsSectionAboutTitle),
            _paragraph(l10n.termsSectionAboutBody),

            _sectionTitle(l10n.termsSectionAccountTitle),
            _paragraph(l10n.termsSectionAccountBody),

            _sectionTitle(l10n.termsSectionContentTitle),
            _paragraph(l10n.termsSectionContentBody),

            _sectionTitle(l10n.termsSectionPrivacyTitle),
            _paragraph(l10n.termsSectionPrivacyBody),

            _sectionTitle(l10n.termsSectionLimitationTitle),
            _paragraph(l10n.termsSectionLimitationBody),

            _sectionTitle(l10n.termsSectionLawTitle),
            _paragraph(l10n.termsSectionLawBody),

            const SizedBox(height: 20),
            _paragraph(l10n.termsClosing),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.terms), centerTitle: true),
        body: content,
      );
    }

    return AppScaffold(
      currentIndex: 3,
      appBar: AppBar(title: Text(l10n.terms), centerTitle: false),
      body: content,
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _paragraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: const TextStyle(height: 1.5),
      ),
    );
  }
}
