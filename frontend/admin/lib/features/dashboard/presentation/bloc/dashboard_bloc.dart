import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_dashboard_data.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardData getDashboardData;

  DashboardBloc(this.getDashboardData) : super(DashboardInitial()) {
    on<LoadDashboard>((event, emit) async {
      emit(DashboardLoading());

      try {
        final result = await getDashboardData();
        emit(DashboardLoaded(result.$1, result.$2));
      } catch (e) {
        emit(DashboardError(e.toString()));
      }
    });
  }
}
