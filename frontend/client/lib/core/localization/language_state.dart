import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LanguageState extends Equatable {
  final Locale? locale; // nullable

  const LanguageState(this.locale);

  @override
  List<Object?> get props => [locale];
}

