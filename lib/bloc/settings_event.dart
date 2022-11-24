part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsEventThemeModeChangeRequested extends SettingsEvent {
  const SettingsEventThemeModeChangeRequested(this.newThemeMode);

  final ThemeMode newThemeMode;

  @override
  List<Object> get props => [newThemeMode];
}

class SettingsEventAccentSourceChangeRequested extends SettingsEvent {
  final AccentColorSource newSource;

  const SettingsEventAccentSourceChangeRequested(this.newSource);
  @override
  List<Object> get props => [newSource];
}

class SettingsEventAccentColorChangeRequested extends SettingsEvent {
  final Color newColor;

  const SettingsEventAccentColorChangeRequested(this.newColor);
  @override
  List<Object> get props => [newColor];
}
