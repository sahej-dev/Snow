import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:date_format/date_format.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:contests_repository/contests_repository.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import '../constants/strings.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc
    extends HydratedBloc<NotificationsEvent, NotificationsState> {
  final AwesomeNotifications _notificationsManager;

  NotificationsBloc(AwesomeNotifications notificationsManager)
      : _notificationsManager = notificationsManager,
        super(
          const NotificationsState(
            notificationsSchedule: ContestNotificationsSchedule(
              [
                Duration(minutes: 5),
                Duration(minutes: 20),
                Duration(hours: 1),
                Duration(hours: 3),
                Duration(hours: 6),
                Duration(hours: 12),
                Duration(hours: 24),
              ],
            ),
            scheduledNotifications: [],
            nextId: 0,
            firstLaunch: true,
          ),
        ) {
    // on<NotificationsEventPermissionsAskedCheckRequested>(
    //     _onPermissionsAskedCheckRequested);
    on<NotificationsEventTrySchedulingUnscheduled>(_onTrySchedulingUnscheduled);
    on<NotificationsEventContestSchedulingRequested>(_onSchedulingRequested);
    on<NotificationsEventContestCancellationRequested>(
        _onCancellationRequested);
    on<NotificationsEventDurationAddRequested>(_onDurationAddRequested);
    on<NotificationsEventDurationRemoveRequested>(_onDurationRemoveRequested);
    on<NotificationsEventExpiredCleanup>(_onScheduleCleanup);
  }

  // void _onPermissionsAskedCheckRequested(
  //     NotificationsEventPermissionsAskedCheckRequested event,
  //     Emitter<NotificationsState> emit) async {
  //   bool permissionsGranted =
  //       await _notificationsManager.isNotificationAllowed();

  //   log(permissionsGranted.toString(), name: 'NOTIF PERMS');

  //   if (permissionsGranted || event.forceHasAsked) {
  //     emit(NotificationsState(
  //       scheduledNotifications: state.scheduledNotifications,
  //       notificationsSchedule: state.notificationsSchedule,
  //       nextId: state.nextId,
  //     ));
  //   } else {
  //     emit(NotificationsState(
  //       scheduledNotifications: state.scheduledNotifications,
  //       notificationsSchedule: state.notificationsSchedule,
  //       nextId: state.nextId,
  //     ));
  //   }
  // }

  void _onTrySchedulingUnscheduled(
      NotificationsEventTrySchedulingUnscheduled event,
      Emitter<NotificationsState> emit) async {
    if (!(await _notificationsManager.isNotificationAllowed())) return;

    List<ContestNotification> notifCopy = [...state.scheduledNotifications];

    List<ContestNotification> unscheduledNotifs =
        notifCopy.where((notif) => !notif.isScheduled).toList();

    if (unscheduledNotifs.isEmpty) return;

    List<ContestNotification> newNotifications =
        notifCopy.where((notif) => notif.isScheduled).toList();

    for (ContestNotification notif in unscheduledNotifs) {
      ContestNotification? newNotif = await _scheduleGetContestNotification(
        event.favContests.firstWhere((c) => c.id == notif.contestId),
        Duration(seconds: notif.seconds),
        notif.id,
      );

      if (newNotif != null) {
        log(newNotif.toString(), name: 'NEW NOTIF');
        newNotifications.add(newNotif);
      } else {
        newNotifications.add(notif);
      }
    }

    emit(NotificationsState(
      scheduledNotifications: newNotifications,
      notificationsSchedule: state.notificationsSchedule,
      nextId: state.nextId,
    ));
  }

  void _onSchedulingRequested(
      NotificationsEventContestSchedulingRequested event,
      Emitter<NotificationsState> emit) async {
    if (event.contest.startDateTime.compareTo(DateTime.now()) <= 0) return;

    List<ContestNotification> newNotifications = [
      ...state.scheduledNotifications
    ];

    int nextId = state.nextId;

    for (Duration duration
        in state.notificationsSchedule.durationsBeforeStartTime) {
      ContestNotification? cNotif = await _scheduleGetContestNotification(
        event.contest,
        duration,
        nextId,
      );

      log(cNotif.toString(), name: 'cNotif');

      if (cNotif != null) {
        nextId += 1;
        newNotifications.add(cNotif);
      }
    }

    emit(NotificationsState(
      scheduledNotifications: newNotifications,
      notificationsSchedule: state.notificationsSchedule,
      nextId: nextId,
    ));
  }

  void _onCancellationRequested(
      NotificationsEventContestCancellationRequested event,
      Emitter<NotificationsState> emit) {
    List<ContestNotification> newNotifs = [...state.scheduledNotifications];
    newNotifs.removeWhere((notif) {
      if (notif.contestId == event.contest.id) {
        _notificationsManager.cancel(notif.id);
        return true;
      }
      return false;
    });

    emit(NotificationsState(
      scheduledNotifications: newNotifs,
      notificationsSchedule: state.notificationsSchedule,
      nextId: state.nextId,
    ));
  }

  void _onDurationAddRequested(NotificationsEventDurationAddRequested event,
      Emitter<NotificationsState> emit) async {
    if (state.notificationsSchedule.durationsBeforeStartTime
        .map((e) => e.inSeconds)
        .contains(event.duration.inSeconds)) return;

    final List<Duration> newDurations = [
      ...state.notificationsSchedule.durationsBeforeStartTime
    ];
    newDurations.add(event.duration);

    final List<ContestNotification> newNotifs = [
      ...state.scheduledNotifications
    ];

    int nextId = state.nextId;
    for (Contest contest in event.favContests) {
      ContestNotification? cNotif = await _scheduleGetContestNotification(
          contest, event.duration, nextId);

      if (cNotif != null) {
        nextId += 1;
        newNotifs.add(cNotif);
      }
    }

    emit(NotificationsState(
      scheduledNotifications: newNotifs,
      notificationsSchedule: ContestNotificationsSchedule(newDurations),
      nextId: nextId,
    ));
  }

  void _onDurationRemoveRequested(
      NotificationsEventDurationRemoveRequested event,
      Emitter<NotificationsState> emit) {
    final List<Duration> newDurations = [
      ...state.notificationsSchedule.durationsBeforeStartTime
    ];

    newDurations
        .removeWhere((dur) => dur.inSeconds == event.duration.inSeconds);

    final List<ContestNotification> newNotifs = [
      ...state.scheduledNotifications
    ];

    newNotifs.removeWhere((notif) {
      if (notif.seconds == event.duration.inSeconds) {
        _notificationsManager.cancel(notif.id);
        return true;
      }

      return false;
    });

    emit(
      NotificationsState(
        scheduledNotifications: newNotifs,
        notificationsSchedule: ContestNotificationsSchedule(newDurations),
        nextId: state.nextId,
      ),
    );
  }

  void _onScheduleCleanup(NotificationsEventExpiredCleanup event,
      Emitter<NotificationsState> emit) async {
    final List<ContestNotification> notifs = [...state.scheduledNotifications];
    final List<String> contestIds =
        event.currentContests.map((c) => c.id).toList();

    notifs.removeWhere((notif) {
      if (!contestIds.contains(notif.contestId)) {
        _notificationsManager.cancel(notif.id);
        return true;
      }

      return false;
    });

    emit(
      NotificationsState(
        scheduledNotifications: notifs,
        notificationsSchedule: state.notificationsSchedule,
        nextId: state.nextId,
      ),
    );
  }

  @override
  NotificationsState? fromJson(Map<String, dynamic> json) {
    log('in load');
    log('${(jsonDecode(json['notifs']) as List<dynamic>).map((e) => ContestNotification.fromJson(e)).toList()}',
        name: 'scheduled notifs');
    // log((jsonDecode(json['notifs']) as List<dynamic>)
    //     .map((e) => ContestNotification.fromJson(e))
    //     .toString());
    // List<dynamic> l = jsonDecode(json['notifs']);

    // List<dynamic> l = (jsonDecode(json['notifs']) as List<dynamic>)
    //     .map((e) => ContestNotification.fromJson(e))
    //     .toList();
    // log(l.toString(), name: 'l');
    // if (l.isNotEmpty) log(l.first.runtimeType.toString(), name: 'l ele type');
    // log(l[0]['id'].toString());
    // log(l[0].runtimeType.toString());
    // log(
    //     (jsonDecode(json['notifs']) as List<dynamic>)
    //         .map((e) => ContestNotification.fromJson(e))
    //         .toList()
    //         .toString(),
    //     name: 'scheduled notifs cache load');

    // log(jsonDecode(json['schedule']).runtimeType.toString(),
    //     name: 'decoded schedule');

    int nextId = int.parse(json['nextId']);

    // protection against potential overflow after years of use
    if (nextId > 1000000000) {
      nextId = 0;
    }
    return NotificationsState(
      scheduledNotifications: (jsonDecode(json['notifs']) as List<dynamic>)
          .map((e) => ContestNotification.fromJson(e))
          .toList(),
      notificationsSchedule:
          ContestNotificationsSchedule.fromJson(jsonDecode(json['schedule'])),
      nextId: nextId,
    );
  }

  @override
  Map<String, dynamic>? toJson(NotificationsState state) {
    log('in write');
    log(jsonEncode(state.notificationsSchedule.toJson()),
        name: 'save schedule');
    log(state.nextId.toString(), name: 'saved next id');

    log(
        jsonEncode(state.scheduledNotifications.map((e) => e.toJson()).toList())
            .toString(),
        name: 'saved notifs');

    return {
      'notifs': jsonEncode(
          state.scheduledNotifications.map((e) => e.toJson()).toList()),
      'schedule': jsonEncode(state.notificationsSchedule.toJson()),
      'nextId': state.nextId.toString(),
    };
  }

  Future<ContestNotification?> _scheduleGetContestNotification(
    Contest contest,
    Duration durationBefore,
    int id,
  ) async {
    final DateTime notifDateTime =
        contest.startDateTime.subtract(durationBefore);

    if (notifDateTime.compareTo(DateTime.now()) <= 0) return null;

    try {
      await _notificationsManager.createNotification(
        content: NotificationContent(
          id: id,
          channelKey: NotificationConstants.contestsRemindersChannelKey,
          title: NotificationConstants.notificationTitle,
          body: _getNotificationBody(contest),
          wakeUpScreen: true,
          fullScreenIntent: true,
        ),
        schedule: NotificationCalendar.fromDate(
          date: notifDateTime,
          allowWhileIdle: true,
        ),
      );
    } catch (e) {
      log(e.toString(), name: 'ERROR!!');
      return ContestNotification(
        id: id,
        contestId: contest.id,
        seconds: durationBefore.inSeconds,
        isScheduled: false,
      );
    }

    return ContestNotification(
      id: id,
      contestId: contest.id,
      seconds: durationBefore.inSeconds,
      isScheduled: true,
    );
  }

  String _getNotificationBody(Contest contest) {
    final DateTime now = DateTime.now();

    late final String date;
    if (contest.startDateTime.day == now.day) {
      date = 'today';
    } else if (contest.startDateTime.day - 1 == now.day) {
      date = 'tomorrow';
    } else {
      date = 'on ${formatDate(contest.startDateTime, [D])}';
    }

    final String time = 'at ${formatDate(
      contest.startDateTime.toLocal(),
      [hh, ':', nn, ' ', am],
    )}';

    return '\'${contest.name}\' on ${contest.judge.name} '
        'starting $date $time';
  }
}
