part of 'contests_bloc.dart';

abstract class ContestsEvent extends Equatable {
  const ContestsEvent();

  @override
  List<Object> get props => [];
}

class ContestsEventLoadRequested extends ContestsEvent {
  const ContestsEventLoadRequested(this.forceFetchOnline);

  final bool forceFetchOnline;
}

class ContestsEventToggledFav extends ContestsEvent {
  const ContestsEventToggledFav(this.contest, this.newToggleStatus);

  final Contest contest;
  final bool newToggleStatus;
}

class ContestsEventJudgeFilterToggleRequested extends ContestsEvent {
  final Judge toggledJudge;
  final bool toggledValue;

  const ContestsEventJudgeFilterToggleRequested(
    this.toggledJudge,
    this.toggledValue,
  );

  @override
  List<Object> get props => [toggledJudge, toggledValue];
}

class ContestsEventStatusFilterToggleRequested extends ContestsEvent {
  final ContestStatus toggledStatus;
  final bool toggledValue;

  const ContestsEventStatusFilterToggleRequested(
    this.toggledStatus,
    this.toggledValue,
  );

  @override
  List<Object> get props => [toggledStatus, toggledValue];
}

class ContestsEventMaxDurationFilterChanged extends ContestsEvent {
  final MaxDurationFilter newDurationFilter;

  const ContestsEventMaxDurationFilterChanged(this.newDurationFilter);

  @override
  List<Object> get props => [newDurationFilter];
}

class ContestsEventSortByRequested extends ContestsEvent {
  final ContestsSortBy contestsSortBy;

  const ContestsEventSortByRequested(this.contestsSortBy);

  @override
  List<Object> get props => [contestsSortBy];
}
