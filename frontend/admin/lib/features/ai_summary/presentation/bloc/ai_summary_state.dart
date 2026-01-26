import '../../domain/entities/ai_summary.dart';

abstract class AiSummaryState {}

class AiSummaryInitial extends AiSummaryState {}

class AiSummaryLoading extends AiSummaryState {}

class AiSummaryLoaded extends AiSummaryState {
  final List<AiSummary> data;
  AiSummaryLoaded(this.data);
}

class AiSummaryError extends AiSummaryState {
  final String message;
  AiSummaryError(this.message);
}
