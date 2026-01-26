abstract class AiSummaryStatusState {}

class AiSummaryStatusInitial extends AiSummaryStatusState {}

class AiSummaryStatusLoading extends AiSummaryStatusState {}

class AiSummaryStatusLoaded extends AiSummaryStatusState {
  final Map<int, bool> statusMap;
  AiSummaryStatusLoaded(this.statusMap);
}

class AiSummaryStatusError extends AiSummaryStatusState {
  final String message;
  AiSummaryStatusError(this.message);
}
