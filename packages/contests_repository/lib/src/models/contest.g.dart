// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contest _$ContestFromJson(Map<String, dynamic> json) => Contest(
      name: json['name'] as String,
      link: json['link'] == null ? null : Uri.parse(json['link'] as String),
      startDateTime: DateTime.parse(json['startDateTime'] as String),
      endDateTime: DateTime.parse(json['endDateTime'] as String),
      duration: Duration(microseconds: json['duration'] as int),
      judge: $enumDecode(_$JudgeEnumMap, json['judge']),
      status: $enumDecode(_$ContestStatusEnumMap, json['status']),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );

Map<String, dynamic> _$ContestToJson(Contest instance) => <String, dynamic>{
      'name': instance.name,
      'link': instance.link?.toString(),
      'startDateTime': instance.startDateTime.toIso8601String(),
      'endDateTime': instance.endDateTime.toIso8601String(),
      'duration': instance.duration.inMicroseconds,
      'judge': _$JudgeEnumMap[instance.judge]!,
      'status': _$ContestStatusEnumMap[instance.status]!,
      'isFavorite': instance.isFavorite,
    };

const _$JudgeEnumMap = {
  Judge.codeforces: 'codeforces',
  Judge.topCoder: 'topCoder',
  Judge.atCoder: 'atCoder',
  Judge.csAcademy: 'csAcademy',
  Judge.codechef: 'codechef',
  Judge.hackerRank: 'hackerRank',
  Judge.hackerEarth: 'hackerEarth',
  Judge.kickStart: 'kickStart',
  Judge.leetCode: 'leetCode',
  Judge.others: 'others',
};

const _$ContestStatusEnumMap = {
  ContestStatus.onGoing: 'onGoing',
  ContestStatus.upcoming: 'upcoming',
  ContestStatus.upcomingIn24Hrs: 'upcomingIn24Hrs',
  ContestStatus.unknown: 'unknown',
};
