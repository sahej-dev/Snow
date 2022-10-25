part of 'settings_bloc.dart';

@JsonSerializable()
class SettingsState extends Equatable {
  const SettingsState({
    required this.themeMode,
    required this.themeModeName,
  });

  final ThemeMode themeMode;
  final String themeModeName;

  @override
  List<Object> get props => [themeMode, themeModeName];
}
