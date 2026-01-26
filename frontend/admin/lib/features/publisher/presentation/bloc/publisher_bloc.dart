import 'package:flutter_bloc/flutter_bloc.dart';
import 'publisher_event.dart';
import 'publisher_state.dart';
import '../../domain/usecases/get_publishers.dart';
import '../../domain/usecases/create_publisher.dart';
import '../../domain/usecases/update_publisher.dart';
import '../../domain/usecases/delete_publisher.dart';

class PublisherBloc extends Bloc<PublisherEvent, PublisherState> {
  final GetPublishers getPublishers;
  final CreatePublisher createPublisher;
  final UpdatePublisher updatePublisher;
  final DeletePublisher deletePublisher;

  PublisherBloc({
    required this.getPublishers,
    required this.createPublisher,
    required this.updatePublisher,
    required this.deletePublisher,
  }) : super(PublisherInitial()) {
    on<LoadPublishers>(_load);
    on<CreatePublisherEvent>(_create);
    on<UpdatePublisherEvent>(_update);
    on<DeletePublisherEvent>(_delete);
  }

  Future<void> _load(_, emit) async {
    emit(PublisherLoading());
    try {
      emit(PublisherLoaded(await getPublishers.execute()));
    } catch (e) {
      emit(PublisherError(e.toString()));
    }
  }

  Future<void> _create(CreatePublisherEvent e, emit) async {
    await createPublisher.execute(
      name: e.name,
      website: e.website,
      logo: e.logo,
    );
    add(LoadPublishers());
  }

  Future<void> _update(UpdatePublisherEvent e, emit) async {
    await updatePublisher.execute(
      id: e.id,
      name: e.name,
      website: e.website,
      logo: e.logo,
    );
    add(LoadPublishers());
  }

  Future<void> _delete(DeletePublisherEvent e, emit) async {
    await deletePublisher.execute(e.id);
    add(LoadPublishers());
  }
}
