import 'package:flutter_bloc/flutter_bloc.dart';
import 'ai_summary_status_event.dart';
import 'ai_summary_status_state.dart';
import '../../data/datasources/ai_summary_status_remote_datasource.dart';

class AiSummaryStatusBloc
    extends Bloc<AiSummaryStatusEvent, AiSummaryStatusState> {
  final AiSummaryStatusRemoteDataSource remote;

  AiSummaryStatusBloc(this.remote) : super(AiSummaryStatusInitial()) {
    on<LoadAiSummaryStatus>((event, emit) async {
      emit(AiSummaryStatusLoading());
      try {
        final list = await remote.getStatus();
        final map = {for (var e in list) e.newsId: e.summarized};
        emit(AiSummaryStatusLoaded(map));
      } catch (e) {
        emit(AiSummaryStatusError(e.toString()));
      }
    });
  }
}
