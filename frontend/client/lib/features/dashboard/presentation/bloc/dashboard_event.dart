abstract class DashboardEvent {}

/// Load pertama kali
class LoadDashboard extends DashboardEvent {}

/// Filter berita berdasarkan kategori
class LoadNewsByCategory extends DashboardEvent {
  final int categoryId;
  LoadNewsByCategory(this.categoryId);
}

class LoadNewsByPublisher extends DashboardEvent {
  final int publisherId;

  LoadNewsByPublisher(this.publisherId);
}
