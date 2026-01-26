abstract class UserEvent {
  const UserEvent();
}

class LoadUsersEvent extends UserEvent {
  const LoadUsersEvent();
}

class SearchUserEvent extends UserEvent {
  final String keyword;
  const SearchUserEvent(this.keyword);
}

class ToggleUserStatusEvent extends UserEvent {
  final int userId;
  const ToggleUserStatusEvent(this.userId);
}
