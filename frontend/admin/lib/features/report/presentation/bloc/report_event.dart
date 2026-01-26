abstract class ReportEvent {}

class LoadReports extends ReportEvent {}

class ResolveReport extends ReportEvent {
  final int id;
  ResolveReport(this.id);
}

class DeleteReportEvent extends ReportEvent {
  final int id;
  DeleteReportEvent(this.id);
}
