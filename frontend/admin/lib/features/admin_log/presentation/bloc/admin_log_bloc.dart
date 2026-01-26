import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_admin_logs.dart';
import 'admin_log_event.dart';
import 'admin_log_state.dart';

class AdminLogBloc extends Bloc<AdminLogEvent, AdminLogState> {
  final GetAdminLogs getAdminLogs;

  AdminLogBloc(this.getAdminLogs) : super(AdminLogInitial()) {
    on<LoadAdminLogs>((event, emit) async {
      emit(AdminLogLoading());
      try {
        final logs = await getAdminLogs();
        emit(AdminLogLoaded(logs));
      } catch (e) {
        emit(AdminLogError(e.toString()));
      }
    });
  }
}
