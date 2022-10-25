part of 'notifications_bloc.dart';

@JsonSerializable()
class ContestNotification extends Equatable {
  final int id;
  final String contestId;
  final int seconds;
  final bool isScheduled;

  const ContestNotification({
    required this.id,
    required this.contestId,
    required this.seconds,
    required this.isScheduled,
  });

  @override
  List<Object?> get props => [id, contestId, seconds, isScheduled];

  factory ContestNotification.fromJson(Map<String, dynamic> json) =>
      _$ContestNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$ContestNotificationToJson(this);
}

@JsonSerializable()
class ContestNotificationsSchedule extends Equatable {
  final List<Duration> durationsBeforeStartTime;

  const ContestNotificationsSchedule(this.durationsBeforeStartTime);

  @override
  List<Object?> get props => [durationsBeforeStartTime];

  factory ContestNotificationsSchedule.fromJson(Map<String, dynamic> json) =>
      _$ContestNotificationsScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$ContestNotificationsScheduleToJson(this);
}

@JsonSerializable()
class NotificationsState extends Equatable {
  final int nextId;
  final List<ContestNotification> scheduledNotifications;
  final ContestNotificationsSchedule notificationsSchedule;
  final bool firstLaunch;

  const NotificationsState({
    required this.scheduledNotifications,
    required this.notificationsSchedule,
    required this.nextId,
    this.firstLaunch = false,
  });

  @override
  List<Object> get props => [
        scheduledNotifications,
        notificationsSchedule,
        firstLaunch,
      ];
}
