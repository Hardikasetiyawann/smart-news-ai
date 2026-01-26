import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailContentResponsive extends StatelessWidget {
  final String content;
  final String linkNews;
  final bool isTablet;

  const DetailContentResponsive({
    super.key,
    required this.content,
    required this.linkNews,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final normalized = content.replaceAll('/n', '\n').trim();

    // =====================
    // HITUNG PARAGRAF
    // =====================
    final paragraphCount = normalized
        .split(RegExp(r'\n\s*\n'))
        .where((e) => e.trim().isNotEmpty)
        .length;

    // =====================
    // SPLIT RULE (FINAL)
    // =====================
    final shouldSplit = isTablet && paragraphCount > 1;

    // =====================
    // 1 KOLOM (HP / 1 PARAGRAF)
    // =====================
    if (!shouldSplit) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _richText(context, normalized),
          const SizedBox(height: 24),
          _sourceLink(context),
        ],
      );
    }

    // =====================
    // 2 KOLOM (TABLET)
    // SPLIT DI AKHIR KALIMAT
    // =====================
    final length = normalized.length;
    final mid = (length / 2).floor();

    final sentenceEndMatches =
        RegExp(r'[.!?]\s').allMatches(normalized).toList();

    int splitIndex = mid;
    for (final m in sentenceEndMatches) {
      if (m.end >= mid) {
        splitIndex = m.end;
        break;
      }
    }

    // fallback safety
    if (splitIndex <= 0 || splitIndex >= length) {
      splitIndex = mid;
    }

    final leftText = normalized.substring(0, splitIndex).trim();
    final rightText = normalized.substring(splitIndex).trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _richText(context, leftText)),
            const SizedBox(width: 32),
            Expanded(child: _richText(context, rightText)),
          ],
        ),
        const SizedBox(height: 24),
        _sourceLink(context),
      ],
    );
  }

  // =====================
  // TEXT RENDER
  // =====================
  Widget _richText(BuildContext context, String text) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(height: 1.6),
    );
  }

  // =====================
  // SOURCE LINK
  // =====================
  Widget _sourceLink(BuildContext context) {
    if (linkNews.isEmpty) return const SizedBox();

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sumber:',
          style: textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            final uri = Uri.parse(linkNews);
            if (await canLaunchUrl(uri)) {
              await launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
              );
            }
          },
          child: Text(
            linkNews,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
