import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/gen_l10n/app_localizations.dart';

import '../bloc/report_bloc.dart';
import '../bloc/report_event.dart';
import '../bloc/report_state.dart';

class ReportPage extends StatefulWidget {
  final String type; // "comment" | "news"
  final int? commentId;
  final int? newsId;

  const ReportPage({
    super.key,
    required this.type,
    this.commentId,
    this.newsId,
  });

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.type == 'comment'
              ? l10n.reportCommentTitle
              : l10n.reportNewsTitle,
        ),
      ),
      body: BlocConsumer<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state is ReportSuccess) {
            showDialog(
              context: context,
              barrierDismissible: false, // wajib tekan OK
              builder: (_) => AlertDialog(
                title: Text(l10n.reportSuccess),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // tutup dialog
                      Navigator.pop(context); // kembali ke halaman sebelumnya
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }

          if (state is ReportFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },

        builder: (context, state) {
          final loading = state is ReportSubmitting;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: l10n.reportHint,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: loading
                            ? null
                            : () => Navigator.pop(context),
                        child: Text(l10n.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: loading ? null : () => _submit(context),
                        child: loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(l10n.report),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _submit(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<ReportBloc>().add(
      ReportSubmitRequested(
        type: widget.type,
        commentId: widget.commentId,
        newsId: widget.newsId,
        content: text,
      ),
    );
  }
}
