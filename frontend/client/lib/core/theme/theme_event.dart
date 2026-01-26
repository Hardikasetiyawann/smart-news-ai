import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTheme extends ThemeEvent {}

class ToggleTheme extends ThemeEvent {
  final bool isDark;
  ToggleTheme(this.isDark);

  @override
  List<Object?> get props => [isDark];
}
