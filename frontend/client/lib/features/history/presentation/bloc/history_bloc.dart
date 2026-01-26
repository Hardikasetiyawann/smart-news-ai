import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_reading_history.dart';
import '../../domain/usecases/delete_history.dart';
import '../../domain/usecases/clear_history.dart';
import '../../domain/usecases/record_read_history.dart';

import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetReadingHistory getHistory;
  final DeleteHistory deleteHistory;
  final ClearHistory clearHistory;
  final RecordReadHistory recordReadHistory;

  HistoryBloc({
    required this.getHistory,
    required this.deleteHistory,
    required this.clearHistory,
    required this.recordReadHistory,
  }) : super(HistoryInitial()) {
    on<LoadHistory>(_onLoad);
    on<RefreshHistory>(_onRefresh);
    on<DeleteHistoryEvent>(_onDeleteSingle);
    on<ClearAllHistory>(_onClearAll);
    on<ToggleSelectionMode>(_onToggleSelectionMode);
    on<ToggleSelectItem>(_onToggleSelectItem);
    on<DeleteSelectedHistory>(_onDeleteSelected);
    on<ToggleSelectAllHistory>(_onToggleSelectAll);
    on<RecordReadHistoryEvent>(_onRecordRead);
  }

  Future<void> _onLoad(LoadHistory event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      final data = await getHistory();
      emit(HistoryLoaded(data));
    } catch (_) {
      emit(HistoryError('Gagal memuat history'));
    }
  }

  Future<void> _onRefresh(
    RefreshHistory event,
    Emitter<HistoryState> emit,
  ) async {
    final data = await getHistory();
    emit(HistoryLoaded(data));
  }

  Future<void> _onDeleteSingle(
    DeleteHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    await deleteHistory(event.newsId);
    add(LoadHistory());
  }

  Future<void> _onClearAll(
    ClearAllHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    await clearHistory();
    add(LoadHistory());
  }

  void _onToggleSelectionMode(
    ToggleSelectionMode event,
    Emitter<HistoryState> emit,
  ) {
    if (state is HistoryLoaded) {
      final s = state as HistoryLoaded;
      emit(s.copyWith(selectionMode: !s.selectionMode, selectedIds: {}));
    }
  }

  void _onToggleSelectItem(
    ToggleSelectItem event,
    Emitter<HistoryState> emit,
  ) {
    if (state is HistoryLoaded) {
      final s = state as HistoryLoaded;
      final ids = Set<int>.from(s.selectedIds);

      ids.contains(event.newsId)
          ? ids.remove(event.newsId)
          : ids.add(event.newsId);

      emit(s.copyWith(selectedIds: ids));
    }
  }

  Future<void> _onDeleteSelected(
    DeleteSelectedHistory event,
    Emitter<HistoryState> emit,
  ) async {
    if (state is HistoryLoaded) {
      final s = state as HistoryLoaded;

      for (final id in s.selectedIds) {
        await deleteHistory(id);
      }

      add(LoadHistory());
    }
  }

  void _onToggleSelectAll(
    ToggleSelectAllHistory event,
    Emitter<HistoryState> emit,
  ) {
    if (state is HistoryLoaded) {
      final s = state as HistoryLoaded;

      final allIds = s.history.map((e) => e.news.id).toSet();
      final isAllSelected = s.selectedIds.length == allIds.length;

      emit(s.copyWith(selectedIds: isAllSelected ? {} : allIds));
    }
  }

  Future<void> _onRecordRead(
    RecordReadHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    await recordReadHistory(event.newsId);
  }
}
