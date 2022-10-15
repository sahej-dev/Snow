part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsEventThemeChangeRequested extends SettingsEvent {
  const SettingsEventThemeChangeRequested(this.newThemeMode);

  final ThemeMode newThemeMode;

  @override
  List<Object> get props => [newThemeMode];
}
