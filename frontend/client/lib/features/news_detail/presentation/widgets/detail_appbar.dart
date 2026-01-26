import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/gen_l10n/app_localizations.dart';

import '../../../reports/domain/usecases/create_report.dart';
import '../../../reports/presentation/bloc/report_bloc.dart';
import '../../../reports/presentation/pages/report_page.dart';

class DetailAppBar extends StatelessWidget {
  final int newsId;

  const DetailAppBar({super.key, required this.newsId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        /// ================= BACK =================
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),

        const Spacer(),

        /// ================= MENU =================
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'report') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) =>
                        ReportBloc(createReport: context.read<CreateReport>()),
                    child: ReportPage(type: 'news', newsId: newsId),
                  ),
                ),
              );
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(value: 'report', child: Text(l10n.report)),
          ],
        ),
      ],
    );
  }
}
