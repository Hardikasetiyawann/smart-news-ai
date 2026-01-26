import 'package:flutter/material.dart';
import '../../domain/entities/ai_summary.dart';

class AiSummaryDetailPage extends StatelessWidget {
  const AiSummaryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AiSummary summary =
        ModalRoute.of(context)!.settings.arguments as AiSummary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Summary Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= NEWS TITLE =================
            Text(
              summary.newsTitle,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // ================= MODEL INFO =================
            Row(
              children: [
                const Icon(Icons.smart_toy, size: 18),
                const SizedBox(width: 6),
                Text(
                  summary.modelName,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ================= SUMMARY BOX =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                summary.summaryText,
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 15, height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
