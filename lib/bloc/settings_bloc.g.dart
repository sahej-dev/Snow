// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsState _$SettingsStateFromJson(Map<String, dynamic> json) =>
    SettingsState(
      themeMode: $enumDecode(_$ThemeModeEnumMap, json['themeMode']),
      themeModeName: json['themeModeName'] as String,
      accentColorSource:
          $enumDecode(_$AccentColorSourceEnumMap, json['accentColorSource']),
      accentColor: SettingsState._colorFromJson(json['accentColor'] as int),
    );

Map<String, dynamic> _$SettingsStateToJson(SettingsState instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'themeModeName': instance.themeModeName,
      'accentColorSource':
          _$AccentColorSourceEnumMap[instance.accentColorSource]!,
      'accentColor': SettingsState._colorToJson(instance.accentColor),
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

const _$AccentColorSourceEnumMap = {
  AccentColorSource.material3: 'material3',
  AccentColorSource.custom: 'custom',
};
