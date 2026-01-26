import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LanguageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadLanguage extends LanguageEvent {}

class ChangeLanguage extends LanguageEvent {
  final Locale locale;
  ChangeLanguage(this.locale);

  @override
  List<Object?> get props => [locale];
}
