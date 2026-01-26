import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/report_entity.dart';
import '../../domain/usecases/create_report.dart';

import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final CreateReport createReport;

  ReportBloc({required this.createReport}) : super(ReportInitial()) {
    on<ReportSubmitRequested>(_onSubmit);
  }

  Future<void> _onSubmit(
    ReportSubmitRequested event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportSubmitting());

    try {
      final report = ReportEntity(
        type: event.type,
        commentId: event.commentId,
        newsId: event.newsId,
        content: event.content,
      );

      await createReport.execute(report);

      emit(ReportSuccess());
    } catch (e) {
      emit(ReportFailure(_mapError(e)));
    }
  }

  String _mapError(Object error) {
    final msg = error.toString();

    if (msg.contains('Unauthorized')) {
      return 'Silakan login terlebih dahulu';
    }

    if (msg.contains('required')) {
      return msg;
    }

    return 'Gagal mengirim laporan';
  }
}
