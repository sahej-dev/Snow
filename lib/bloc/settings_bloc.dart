import 'package:flutter/material.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';

import '../constants/strings.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  SettingsBloc()
      : super(const SettingsState(
          themeMode: ThemeMode.system,
          themeModeName: SettingsConstants.systemThemeName,
        )) {
    on<SettingsEventThemeChangeRequested>(_onThemeChange);
  }

  void _onThemeChange(
      SettingsEventThemeChangeRequested event, Emitter<SettingsState> emit) {
    if (event.newThemeMode == state.themeMode) return;

    emit(SettingsState(
      themeMode: event.newThemeMode,
      themeModeName: _getThemeModeName(event.newThemeMode),
    ));
  }

  String _getThemeModeName(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return SettingsConstants.systemThemeName;
      case ThemeMode.light:
        return SettingsConstants.lightThemeName;
      case ThemeMode.dark:
      default:
        return SettingsConstants.darkThemeName;
    }
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    ThemeMode themeMode = ThemeMode.values.byName(json['themeMode']);
    return SettingsState(
      themeMode: themeMode,
      themeModeName: _getThemeModeName(themeMode),
    );
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return {'themeMode': state.themeMode.name};
  }
}
