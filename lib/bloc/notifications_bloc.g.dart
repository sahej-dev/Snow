// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContestNotification _$ContestNotificationFromJson(Map<String, dynamic> json) =>
    ContestNotification(
      id: json['id'] as int,
      contestId: json['contestId'] as String,
      seconds: json['seconds'] as int,
      isScheduled: json['isScheduled'] as bool,
    );

Map<String, dynamic> _$ContestNotificationToJson(
        ContestNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contestId': instance.contestId,
      'seconds': instance.seconds,
      'isScheduled': instance.isScheduled,
    };

ContestNotificationsSchedule _$ContestNotificationsScheduleFromJson(
        Map<String, dynamic> json) =>
    ContestNotificationsSchedule(
      (json['durationsBeforeStartTime'] as List<dynamic>)
          .map((e) => Duration(microseconds: e as int))
          .toList(),
    );

Map<String, dynamic> _$ContestNotificationsScheduleToJson(
        ContestNotificationsSchedule instance) =>
    <String, dynamic>{
      'durationsBeforeStartTime': instance.durationsBeforeStartTime
          .map((e) => e.inMicroseconds)
          .toList(),
    };

NotificationsState _$NotificationsStateFromJson(Map<String, dynamic> json) =>
    NotificationsState(
      scheduledNotifications: (json['scheduledNotifications'] as List<dynamic>)
          .map((e) => ContestNotification.fromJson(e as Map<String, dynamic>))
          .toList(),
      notificationsSchedule: ContestNotificationsSchedule.fromJson(
          json['notificationsSchedule'] as Map<String, dynamic>),
      nextId: json['nextId'] as int,
      firstLaunch: json['firstLaunch'] as bool? ?? false,
    );

Map<String, dynamic> _$NotificationsStateToJson(NotificationsState instance) =>
    <String, dynamic>{
      'nextId': instance.nextId,
      'scheduledNotifications': instance.scheduledNotifications,
      'notificationsSchedule': instance.notificationsSchedule,
      'firstLaunch': instance.firstLaunch,
    };
