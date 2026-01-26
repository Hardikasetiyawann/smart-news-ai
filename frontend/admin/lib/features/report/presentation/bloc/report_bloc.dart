import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_reports.dart';
import '../../domain/usecases/update_report_status.dart';
import '../../domain/usecases/delete_report.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final GetReports getReports;
  final UpdateReportStatus updateStatus;
  final DeleteReport deleteReport;

  ReportBloc({
    required this.getReports,
    required this.updateStatus,
    required this.deleteReport,
  }) : super(ReportInitial()) {
    on<LoadReports>(_onLoad);
    on<ResolveReport>(_onResolve);
    on<DeleteReportEvent>(_onDelete);
  }

  Future<void> _onLoad(LoadReports event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      final data = await getReports();
      emit(ReportLoaded(data));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  Future<void> _onResolve(
    ResolveReport event,
    Emitter<ReportState> emit,
  ) async {
    await updateStatus(event.id, "resolved");
    add(LoadReports());
  }

  Future<void> _onDelete(
    DeleteReportEvent event,
    Emitter<ReportState> emit,
  ) async {
    await deleteReport(event.id);
    add(LoadReports());
  }
}
