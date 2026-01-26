
import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_event.dart';
import 'language_state.dart';
import 'language_storage.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState(null)) {
    on<LoadLanguage>(_onLoad);
    on<ChangeLanguage>(_onChange);
  }

  Future<void> _onLoad(
    LoadLanguage event,
    Emitter<LanguageState> emit,
  ) async {
    final locale = await LanguageStorage.loadLanguage();
    emit(LanguageState(locale)); // null = system
  }

  Future<void> _onChange(
    ChangeLanguage event,
    Emitter<LanguageState> emit,
  ) async {
    await LanguageStorage.saveLanguage(event.locale);
    emit(LanguageState(event.locale));
  }
}

