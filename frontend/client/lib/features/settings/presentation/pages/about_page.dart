import 'package:flutter/material.dart';
import 'package:client/gen_l10n/app_localizations.dart';

import '../../../../core/layout/app_scaffold.dart';
import '../../../../core/responsive/responsive.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
            const _AppLogo(),
            const SizedBox(height: 24),

            _SectionTitle(l10n.aboutSectionAppTitle),
            _Paragraph(l10n.aboutSectionAppBody1),
            _Paragraph(l10n.aboutSectionAppBody2),

            const SizedBox(height: 20),
            _SectionTitle(l10n.aboutSectionVisionTitle),
            _Paragraph(l10n.aboutSectionVisionBody1),
            _Paragraph(l10n.aboutSectionVisionBody2),

            const SizedBox(height: 20),
            _SectionTitle(l10n.aboutSectionFeatureTitle),
            _Bullet(l10n.aboutFeature1),
            _Bullet(l10n.aboutFeature2),
            _Bullet(l10n.aboutFeature3),
            _Bullet(l10n.aboutFeature4),
            _Bullet(l10n.aboutFeature5),

            const SizedBox(height: 20),
            _SectionTitle(l10n.aboutSectionCommitmentTitle),
            _Paragraph(l10n.aboutSectionCommitmentBody),

            const SizedBox(height: 32),
            Center(
              child: Text(
                l10n.aboutFooter,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.about), centerTitle: true),
        body: content,
      );
    }

    return AppScaffold(
      currentIndex: 3,
      appBar: AppBar(title: Text(l10n.about), centerTitle: false),
      body: content,
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/logo/Frame.png',
          width: 72,
          height: 72,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 12),
        const Text(
          'LensNews',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  final String text;
  const _Paragraph(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(height: 1.5)),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(child: Text(text, style: const TextStyle(height: 1.4))),
        ],
      ),
    );
  }
}
