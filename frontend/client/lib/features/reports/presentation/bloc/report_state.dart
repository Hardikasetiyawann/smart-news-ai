abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportSubmitting extends ReportState {}

class ReportSuccess extends ReportState {}

class ReportFailure extends ReportState {
  final String message;
  ReportFailure(this.message);
}
