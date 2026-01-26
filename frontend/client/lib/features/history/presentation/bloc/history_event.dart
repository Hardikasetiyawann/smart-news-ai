abstract class HistoryEvent {}

class LoadHistory extends HistoryEvent {}

class RefreshHistory extends HistoryEvent {}

class DeleteHistoryEvent extends HistoryEvent {
  final int newsId;
  DeleteHistoryEvent(this.newsId);
}

class ClearAllHistory extends HistoryEvent {}

/// UI EVENTS
class ToggleSelectionMode extends HistoryEvent {}

class ToggleSelectItem extends HistoryEvent {
  final int newsId;
  ToggleSelectItem(this.newsId);
}

class ToggleSelectAllHistory extends HistoryEvent {}

class DeleteSelectedHistory extends HistoryEvent {}

class RecordReadHistoryEvent extends HistoryEvent {
  final int newsId;
  RecordReadHistoryEvent(this.newsId);
}
