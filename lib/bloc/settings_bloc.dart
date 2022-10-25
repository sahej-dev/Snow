import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

import '../constants/strings.dart';

part 'settings_event.dart';
part 'settings_state.dart';

part 'settings_bloc.g.dart';

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
    try {
      return _$SettingsStateFromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(SettingsState state) =>
      _$SettingsStateToJson(state);
}
