import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_all_ai_summaries.dart';
import 'ai_summary_event.dart';
import 'ai_summary_state.dart';

class AiSummaryBloc extends Bloc<AiSummaryEvent, AiSummaryState> {
  final GetAllAiSummaries getAll;

  AiSummaryBloc(this.getAll) : super(AiSummaryInitial()) {
    on<LoadAiSummaries>((event, emit) async {
      emit(AiSummaryLoading());
      try {
        final data = await getAll();
        emit(AiSummaryLoaded(data));
      } catch (e) {
        emit(AiSummaryError(e.toString()));
      }
    });
  }
}
