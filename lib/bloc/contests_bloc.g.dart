// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contests_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaxDurationFilter _$MaxDurationFilterFromJson(Map<String, dynamic> json) =>
    MaxDurationFilter(
      Duration(microseconds: json['duration'] as int),
      json['isOn'] as bool,
    );

Map<String, dynamic> _$MaxDurationFilterToJson(MaxDurationFilter instance) =>
    <String, dynamic>{
      'duration': instance.duration.inMicroseconds,
      'isOn': instance.isOn,
    };

ContestsStateInitial _$ContestsStateInitialFromJson(
        Map<String, dynamic> json) =>
    ContestsStateInitial(
      selectedJudges: (json['selectedJudges'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$JudgeEnumMap, e))
              .toList() ??
          const [
            Judge.atCoder,
            Judge.codechef,
            Judge.codeforces,
            Judge.csAcademy,
            Judge.hackerEarth,
            Judge.hackerRank,
            Judge.kickStart,
            Judge.leetCode,
            Judge.topCoder,
            Judge.others
          ],
      selectedStatuses: (json['selectedStatuses'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$ContestStatusEnumMap, e))
              .toList() ??
          const [
            ContestStatus.upcomingIn24Hrs,
            ContestStatus.upcoming,
            ContestStatus.onGoing
          ],
      maxDurationFilter: json['maxDurationFilter'] == null
          ? const MaxDurationFilter(MaxDurationFilter.infiniteDuration, false)
          : MaxDurationFilter.fromJson(
              json['maxDurationFilter'] as Map<String, dynamic>),
      contestsSortBy: $enumDecodeNullable(
              _$ContestsSortByEnumMap, json['contestsSortBy']) ??
          ContestsSortBy.nearestFirst,
    );

Map<String, dynamic> _$ContestsStateInitialToJson(
        ContestsStateInitial instance) =>
    <String, dynamic>{
      'selectedJudges':
          instance.selectedJudges.map((e) => _$JudgeEnumMap[e]!).toList(),
      'selectedStatuses': instance.selectedStatuses
          .map((e) => _$ContestStatusEnumMap[e]!)
          .toList(),
      'maxDurationFilter': instance.maxDurationFilter,
      'contestsSortBy': _$ContestsSortByEnumMap[instance.contestsSortBy]!,
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

const _$ContestsSortByEnumMap = {
  ContestsSortBy.nearestFirst: 'nearestFirst',
  ContestsSortBy.nearestLast: 'nearestLast',
  ContestsSortBy.shorterFirst: 'shorterFirst',
  ContestsSortBy.longerFirst: 'longerFirst',
};
