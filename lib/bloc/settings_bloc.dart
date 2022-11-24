import 'dart:developer';

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
          accentColorSource: AccentColorSource.material3,
          accentColor: Color(0xff673ab7),
        )) {
    on<SettingsEventThemeModeChangeRequested>(_onThemeChange);
    on<SettingsEventAccentSourceChangeRequested>(_onAccentSourceToggled);
    on<SettingsEventAccentColorChangeRequested>(_onAccentColorChanged);
  }

  void _onThemeChange(SettingsEventThemeModeChangeRequested event,
      Emitter<SettingsState> emit) {
    if (event.newThemeMode == state.themeMode) return;

    emit(SettingsState(
      themeMode: event.newThemeMode,
      themeModeName: _getThemeModeName(event.newThemeMode),
      accentColorSource: state.accentColorSource,
      accentColor: state.accentColor,
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

  void _onAccentSourceToggled(SettingsEventAccentSourceChangeRequested event,
      Emitter<SettingsState> emit) {
    if (event.newSource == state.accentColorSource) return;

    emit(SettingsState(
      themeMode: state.themeMode,
      themeModeName: state.themeModeName,
      accentColorSource: event.newSource,
      accentColor: state.accentColor,
    ));
  }

  void _onAccentColorChanged(SettingsEventAccentColorChangeRequested event,
      Emitter<SettingsState> emit) {
    if (state.accentColor == event.newColor) return;

    emit(SettingsState(
      themeMode: state.themeMode,
      themeModeName: state.themeModeName,
      accentColorSource: state.accentColorSource,
      accentColor: event.newColor,
    ));
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
