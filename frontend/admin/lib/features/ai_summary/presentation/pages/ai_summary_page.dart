import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/ai_summary_bloc.dart';
import '../bloc/ai_summary_event.dart';
import '../bloc/ai_summary_state.dart';

class AiSummaryPage extends StatefulWidget {
  const AiSummaryPage({super.key});

  @override
  State<AiSummaryPage> createState() => _AiSummaryPageState();
}

class _AiSummaryPageState extends State<AiSummaryPage> {
  @override
  void initState() {
    super.initState();
    // Load data sekali saat page dibuka
    context.read<AiSummaryBloc>().add(LoadAiSummaries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Summaries')),
      body: BlocBuilder<AiSummaryBloc, AiSummaryState>(
        builder: (context, state) {
          if (state is AiSummaryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AiSummaryError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is AiSummaryLoaded) {
            if (state.data.isEmpty) {
              return const Center(child: Text('Belum ada AI Summary'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 48,
                dataRowMinHeight: 64,
                dataRowMaxHeight: 80,
                showCheckboxColumn: false,
                columns: const [
                  DataColumn(label: Text('News')),
                  DataColumn(label: Text('Model')),
                  DataColumn(label: Text('Summary')),
                ],
                rows: state.data.map((e) {
                  return DataRow(
                    onSelectChanged: (_) {
                      Navigator.pushNamed(
                        context,
                        '/ai-summary/detail',
                        arguments: e,
                      );
                    },
                    cells: [
                      // ================= NEWS TITLE =================
                      DataCell(
                        SizedBox(
                          width: 280,
                          child: Text(
                            e.newsTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),

                      // ================= MODEL NAME =================
                      DataCell(
                        SizedBox(
                          width: 320,
                          child: Text(
                            e.modelName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      // ================= SUMMARY (3 BARIS) =================
                      DataCell(
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 450,
                            maxHeight: 72, // ± tinggi 3 baris
                          ),
                          child: Text(
                            e.summaryText,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(height: 1.4),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
