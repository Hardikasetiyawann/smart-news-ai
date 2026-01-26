abstract class AdminEvent {}

// LOAD
class LoadAdmins extends AdminEvent {}

// CREATE
class CreateAdminEvent extends AdminEvent {
  final String username;
  final String email;
  final String password;
  final String fullName;

  CreateAdminEvent({
    required this.username,
    required this.email,
    required this.password,
    required this.fullName,
  });
}

// UPDATE
class UpdateAdminEvent extends AdminEvent {
  final int id;
  final String username;
  final String email;
  final String fullName;
  final String? password;

  UpdateAdminEvent({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    this.password,
  });
}

// DELETE
class DeleteAdminEvent extends AdminEvent {
  final int id;
  DeleteAdminEvent(this.id);
}

class SearchAdminEvent extends AdminEvent {
  final String keyword;
  SearchAdminEvent(this.keyword);
}
