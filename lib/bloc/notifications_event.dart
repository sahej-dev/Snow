part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

// class NotificationsEventTest extends NotificationsEvent {
//   const NotificationsEventTest();
// }

// class NotificationsEventPermissionsAskedCheckRequested
//     extends NotificationsEvent {
//   const NotificationsEventPermissionsAskedCheckRequested({
//     this.forceHasAsked = false,
//   });

//   final bool forceHasAsked;
// }

class NotificationsEventTrySchedulingUnscheduled extends NotificationsEvent {
  const NotificationsEventTrySchedulingUnscheduled(this.favContests);

  final List<Contest> favContests;
}

class NotificationsEventContestSchedulingRequested extends NotificationsEvent {
  const NotificationsEventContestSchedulingRequested(this.contest);

  final Contest contest;

  @override
  List<Object> get props => [contest];
}

class NotificationsEventContestCancellationRequested
    extends NotificationsEvent {
  const NotificationsEventContestCancellationRequested(this.contest);

  final Contest contest;

  @override
  List<Object> get props => [contest];
}

class NotificationsEventDurationAddRequested extends NotificationsEvent {
  const NotificationsEventDurationAddRequested(this.duration, this.favContests);

  final Duration duration;
  final List<Contest> favContests;

  @override
  List<Object> get props => [duration, favContests];
}

class NotificationsEventDurationRemoveRequested extends NotificationsEvent {
  const NotificationsEventDurationRemoveRequested(
      this.duration, this.favContests);

  final Duration duration;
  final List<Contest> favContests;

  @override
  List<Object> get props => [duration, favContests];
}

class NotificationsEventExpiredCleanup extends NotificationsEvent {
  const NotificationsEventExpiredCleanup(this.currentContests);

  final List<Contest> currentContests;

  @override
  List<Object> get props => [currentContests];
}
