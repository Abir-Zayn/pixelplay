import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

enum ThemeEvent { toggleTheme, setLightTheme, setDarkTheme, setSystem }

class ThemeCubit extends HydratedBloc<ThemeEvent, ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    on<ThemeEvent>((event, emit) {
      switch (event) {
        case ThemeEvent.toggleTheme:
          emit(_toggleTheme(state));
        case ThemeEvent.setLightTheme:
          emit(ThemeMode.light);
        case ThemeEvent.setDarkTheme:
          emit(ThemeMode.dark);
        case ThemeEvent.setSystem:
          emit(ThemeMode.system);
      }
    });
  }

  void toggleTheme() => add(ThemeEvent.toggleTheme);
  void setLightTheme() => add(ThemeEvent.setLightTheme);
  void setDarkTheme() => add(ThemeEvent.setDarkTheme);
  void setSystemTheme() => add(ThemeEvent.setSystem);

  void updateTheme(ThemeMode theme) => emit(theme);

  ThemeMode _toggleTheme(ThemeMode currentTheme) {
    switch (currentTheme) {
      case ThemeMode.system:
        // When in system mode, toggle to light or dark based on system preference
        final brightness =
            SchedulerBinding.instance.platformDispatcher.platformBrightness;
        return brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
      case ThemeMode.light:
        return ThemeMode.dark;
      case ThemeMode.dark:
        return ThemeMode.system;
    }
  }

  bool get isDarkModeOn {
    if (state == ThemeMode.system) {
      final brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return state == ThemeMode.dark;
    }
  }

  @override
  ThemeMode fromJson(Map<String, dynamic> json) {
    return ThemeMode.values[json['theme'] ?? 0];
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    // TODO: implement toJson
    return {'theme': state.index};
  }
}
