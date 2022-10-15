part of 'notifications_bloc.dart';

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

  factory ContestNotification.fromJson(Map<String, dynamic> json) {
    return ContestNotification(
      id: int.parse(json['id']),
      contestId: json['cid'],
      seconds: int.parse(json['secs']),
      isScheduled: json['isScheduled'] == '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'cid': contestId,
      'secs': seconds.toString(),
      'isScheduled': isScheduled ? '1' : '0',
    };
  }
}

class ContestNotificationsSchedule extends Equatable {
  final List<Duration> durationsBeforeStartTime;

  const ContestNotificationsSchedule(this.durationsBeforeStartTime);

  @override
  List<Object?> get props => [durationsBeforeStartTime];

  factory ContestNotificationsSchedule.fromJson(Map<String, dynamic> json) {
    return ContestNotificationsSchedule(
      (json['durations'] as List)
          .map((d) => Duration(seconds: int.parse(d.toString())))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'durations':
          durationsBeforeStartTime.map((d) => d.inSeconds.toString()).toList(),
    };
  }
}

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
