import 'package:flutter/material.dart'; // 🔥 WAJIB
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_event.dart';
import 'theme_state.dart';
import 'theme_storage.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(ThemeMode.system)) {
    on<LoadTheme>(_onLoad);
    on<ToggleTheme>(_onToggle);
  }

  Future<void> _onLoad(
    LoadTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final mode = await ThemeStorage.loadTheme();
    emit(ThemeState(mode));
  }

  Future<void> _onToggle(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final mode = event.isDark
        ? ThemeMode.dark
        : ThemeMode.light;

    await ThemeStorage.saveTheme(mode);
    emit(ThemeState(mode));
  }
}

