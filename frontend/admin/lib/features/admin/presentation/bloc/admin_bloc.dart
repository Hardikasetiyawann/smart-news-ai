import 'package:flutter_bloc/flutter_bloc.dart';
import 'admin_event.dart';
import 'admin_state.dart';

import '../../domain/entities/admin.dart'; // 🆕
import '../../domain/usecases/get_admins.dart';
import '../../domain/usecases/create_admin.dart';
import '../../domain/usecases/update_admin.dart';
import '../../domain/usecases/delete_admin.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final GetAdmins getAdmins;
  final CreateAdmin createAdmin;
  final UpdateAdmin updateAdmin;
  final DeleteAdmin deleteAdmin;

  // ================= SEARCH CACHE =================
  List<Admin> _allAdmins = []; // 🆕

  AdminBloc({
    required this.getAdmins,
    required this.createAdmin,
    required this.updateAdmin,
    required this.deleteAdmin,
  }) : super(AdminInitial()) {
    // ================= LOAD =================
    on<LoadAdmins>((event, emit) async {
      emit(AdminLoading());
      try {
        _allAdmins = await getAdmins(); // 🆕 simpan data asli
        emit(AdminLoaded(_allAdmins));
      } catch (e) {
        emit(AdminError(e.toString()));
      }
    });

    // ================= SEARCH =================
    on<SearchAdminEvent>((event, emit) {
      final keyword = event.keyword.toLowerCase();

      final filtered = _allAdmins.where((admin) {
        return admin.username.toLowerCase().contains(keyword) ||
            admin.email.toLowerCase().contains(keyword) ||
            admin.fullName.toLowerCase().contains(keyword);
      }).toList();

      emit(AdminLoaded(filtered));
    });

    // ================= CREATE =================
    on<CreateAdminEvent>((event, emit) async {
      emit(AdminLoading());
      try {
        await createAdmin(
          username: event.username,
          email: event.email,
          password: event.password,
          fullName: event.fullName,
        );
        emit(AdminSuccess('Admin berhasil ditambahkan'));
        add(LoadAdmins()); // reload + reset cache
      } catch (e) {
        emit(AdminError(e.toString()));
      }
    });

    // ================= UPDATE =================
    on<UpdateAdminEvent>((event, emit) async {
      emit(AdminLoading());
      try {
        await updateAdmin(
          id: event.id,
          username: event.username,
          email: event.email,
          fullName: event.fullName,
          password: event.password,
        );
        emit(AdminSuccess('Admin berhasil diperbarui'));
        add(LoadAdmins());
      } catch (e) {
        emit(AdminError(e.toString()));
      }
    });

    // ================= DELETE =================
    on<DeleteAdminEvent>((event, emit) async {
      emit(AdminLoading());
      try {
        await deleteAdmin(event.id);
        emit(AdminSuccess('Admin berhasil dihapus'));
        add(LoadAdmins());
      } catch (e) {
        emit(AdminError(e.toString()));
      }
    });
  }
}
