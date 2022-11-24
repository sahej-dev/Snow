part of 'settings_bloc.dart';

enum AccentColorSource { material3, custom }

@JsonSerializable()
class SettingsState extends Equatable {
  const SettingsState({
    required this.themeMode,
    required this.themeModeName,
    required this.accentColorSource,
    required this.accentColor,
  });

  final ThemeMode themeMode;
  final String themeModeName;
  final AccentColorSource accentColorSource;

  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color accentColor;

  @override
  List<Object> get props => [
        themeMode,
        themeModeName,
        accentColorSource,
        accentColor,
      ];

  static int _colorToJson(Color color) => color.value;
  static Color _colorFromJson(int value) => Color(value);
}
