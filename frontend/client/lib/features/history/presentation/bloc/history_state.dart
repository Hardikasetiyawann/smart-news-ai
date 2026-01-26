import '../../domain/entities/reading_history.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<ReadingHistory> history;
  final bool selectionMode;
  final Set<int> selectedIds;

  HistoryLoaded(
    this.history, {
    this.selectionMode = false,
    this.selectedIds = const {},
  });

  HistoryLoaded copyWith({
    List<ReadingHistory>? history,
    bool? selectionMode,
    Set<int>? selectedIds,
  }) {
    return HistoryLoaded(
      history ?? this.history,
      selectionMode: selectionMode ?? this.selectionMode,
      selectedIds: selectedIds ?? this.selectedIds,
    );
  }
}

class HistoryError extends HistoryState {
  final String message;
  HistoryError(this.message);
}
