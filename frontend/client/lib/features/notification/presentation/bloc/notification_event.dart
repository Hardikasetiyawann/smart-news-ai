import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationEvent {
  final bool refresh;

  const LoadNotifications({this.refresh = false});
}

class LoadMoreNotifications extends NotificationEvent {}

class MarkNotificationReadEvent extends NotificationEvent {
  final int id;

  const MarkNotificationReadEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteNotificationEvent extends NotificationEvent {
  final int id;

  const DeleteNotificationEvent(this.id);

  @override
  List<Object?> get props => [id];
}
