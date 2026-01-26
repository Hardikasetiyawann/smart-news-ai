import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_notification.dart';
import '../../domain/usecases/mark_notification_read.dart';
import '../../domain/usecases/delete_notification.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc
    extends Bloc<NotificationEvent, NotificationState> {
  final GetNotifications getNotifications;
  final MarkNotificationRead markNotificationRead;
  final DeleteNotification deleteNotification;

  static const int _pageSize = 20;
  int _offset = 0;
  bool _hasReachedMax = false;
  final List<NotificationEntity> _cache = [];

  NotificationBloc({
    required this.getNotifications,
    required this.markNotificationRead,
    required this.deleteNotification,
  }) : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoad);
    on<LoadMoreNotifications>(_onLoadMore);
    on<MarkNotificationReadEvent>(_onMarkRead);
    on<DeleteNotificationEvent>(_onDelete);
  }

  Future<void> _onLoad(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      if (!event.refresh) emit(NotificationLoading());

      _offset = 0;
      _hasReachedMax = false;
      _cache.clear();

      final data = await getNotifications(
        limit: _pageSize,
        offset: _offset,
      );

      if (data.isEmpty) {
        emit(NotificationEmpty());
        return;
      }

      _cache.addAll(data);
      _hasReachedMax = data.length < _pageSize;

      emit(
        NotificationLoaded(
          notifications: List.from(_cache),
          hasReachedMax: _hasReachedMax,
        ),
      );
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    if (_hasReachedMax || state is! NotificationLoaded) return;

    try {
      _offset += _pageSize;

      final data = await getNotifications(
        limit: _pageSize,
        offset: _offset,
      );

      if (data.isEmpty) {
        _hasReachedMax = true;
      } else {
        _cache.addAll(data);
        _hasReachedMax = data.length < _pageSize;
      }

      emit(
        NotificationLoaded(
          notifications: List.from(_cache),
          hasReachedMax: _hasReachedMax,
        ),
      );
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onMarkRead(
    MarkNotificationReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    await markNotificationRead(event.id);
    add(const LoadNotifications(refresh: true));
  }

  Future<void> _onDelete(
    DeleteNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    await deleteNotification(event.id);
    add(const LoadNotifications(refresh: true));
  }
}
