import 'package:flutter/material.dart';
import 'package:client/gen_l10n/app_localizations.dart';

import '../../../../core/layout/app_scaffold.dart';
import '../../../../core/responsive/responsive.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
                    l10n.privacyHeader,
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.privacyEffectiveDate,
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _paragraph(l10n.privacyIntro1),
            _paragraph(l10n.privacyIntro2),

            _sectionTitle(l10n.privacySectionCollectTitle),
            _paragraph(l10n.privacySectionCollectBody),

            _sectionTitle(l10n.privacySectionUseTitle),
            _paragraph(l10n.privacySectionUseBody),

            _sectionTitle(l10n.privacySectionShareTitle),
            _paragraph(l10n.privacySectionShareBody),

            _sectionTitle(l10n.privacySectionSecurityTitle),
            _paragraph(l10n.privacySectionSecurityBody),

            _sectionTitle(l10n.privacySectionRetentionTitle),
            _paragraph(l10n.privacySectionRetentionBody),

            _sectionTitle(l10n.privacySectionRightsTitle),
            _paragraph(l10n.privacySectionRightsBody),

            _sectionTitle(l10n.privacySectionChangeTitle),
            _paragraph(l10n.privacySectionChangeBody),

            const SizedBox(height: 20),
            _paragraph(l10n.privacyClosing),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.privacyPolicy), centerTitle: true),
        body: content,
      );
    }

    return AppScaffold(
      currentIndex: 3,
      appBar: AppBar(title: Text(l10n.privacyPolicy), centerTitle: false),
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
