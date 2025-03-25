import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedBloc<void, ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void updateTheme(ThemeMode theme) => emit(theme);
  

  @override
  ThemeMode fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    return ThemeMode.values[json['theme'] ?? 0];
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    // TODO: implement toJson
    return {'theme': state.index};
  }
}
