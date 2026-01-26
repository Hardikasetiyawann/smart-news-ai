import 'package:flutter/material.dart';
import 'package:client/gen_l10n/app_localizations.dart';

import '../../../../core/layout/app_scaffold.dart';
import '../../../../core/responsive/responsive.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

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
            _IntroSection(title: l10n.helpIntroTitle, desc: l10n.helpIntroDesc),
            const SizedBox(height: 24),

            _FaqItem(question: l10n.faqWhatIsTitle, answer: l10n.faqWhatIsDesc),
            _FaqItem(question: l10n.faqFreeTitle, answer: l10n.faqFreeDesc),
            _FaqItem(
              question: l10n.faqChangeLanguageTitle,
              answer: l10n.faqChangeLanguageDesc,
            ),
            _FaqItem(
              question: l10n.faqNotificationSettingTitle,
              answer: l10n.faqNotificationSettingDesc,
            ),
            _FaqItem(
              question: l10n.faqNoNotificationTitle,
              answer: l10n.faqNoNotificationDesc,
            ),
            _FaqItem(
              question: l10n.faqSaveNewsTitle,
              answer: l10n.faqSaveNewsDesc,
            ),
            _FaqItem(
              question: l10n.faqShareNewsTitle,
              answer: l10n.faqShareNewsDesc,
            ),
            _FaqItem(
              question: l10n.faqContactTitle,
              answer: l10n.faqContactDesc,
            ),
          ],
        ),
      ),
    );

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.help), centerTitle: true),
        body: content,
      );
    }

    return AppScaffold(
      currentIndex: 3,
      appBar: AppBar(title: Text(l10n.help), centerTitle: false),
      body: content,
    );
  }
}

class _IntroSection extends StatelessWidget {
  final String title;
  final String desc;

  const _IntroSection({required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(desc, style: const TextStyle(height: 1.5)),
      ],
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 8),

      expandedAlignment: Alignment.centerLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,

      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(
            answer,
            textAlign: TextAlign.start,
            style: const TextStyle(height: 1.5),
          ),
        ),
      ],
    );
  }
}
