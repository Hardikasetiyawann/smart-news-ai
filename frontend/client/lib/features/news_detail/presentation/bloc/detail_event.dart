abstract class DetailEvent {}

class DetailLoadRequested extends DetailEvent {
  final int newsId;

  DetailLoadRequested(this.newsId);
}

class DetailToggleAiSummary extends DetailEvent {}

class DetailToggleLike extends DetailEvent {}

class DetailReloadInteraction extends DetailEvent {}

class DetailToggleBookmark extends DetailEvent {}
