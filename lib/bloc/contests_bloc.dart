import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:contests_repository/contests_repository.dart';

part 'contests_event.dart';
part 'contests_state.dart';

class ContestsBloc extends HydratedBloc<ContestsEvent, ContestsState> {
  final ContestsRepository _contestsRepository;
  ContestsBloc({required ContestsRepository contestsRepository})
      : _contestsRepository = contestsRepository,
        super(const ContestsStateInitial()) {
    on<ContestsEventLoadRequested>(_onContestsLoadRequested);
    on<ContestsEventToggledFav>(_onContestsToggledFav);
    on<ContestsEventJudgeFilterToggleRequested>(_onJudgeFilterToggled);
    on<ContestsEventStatusFilterToggleRequested>(_onStatusFilterToggled);
    on<ContestsEventMaxDurationFilterChanged>(_onMaxDurationFilterChanged);
  }

  void _onContestsLoadRequested(
    ContestsEventLoadRequested event,
    Emitter<ContestsState> emit,
  ) async {
    emit(ContestsStateLoading(
      selectedJudges: state.selectedJudges,
      selectedStatuses: state.selectedStatuses,
      maxDurationFilter: state.maxDurationFilter,
    ));

    List<Contest>? contests = await _contestsRepository.getContestsList(
      forceNetworkFetch: event.forceFetchOnline,
    );

    if (contests == null) {
      emit(ContestsStateAllLoadFailed(
        state.selectedJudges,
        state.selectedStatuses,
        state.maxDurationFilter,
      ));
    } else {
      emit(ContestsStateLoaded(
        contests,
        _contestsRepository.onlineLoadStatus,
        _contestsRepository.cacheLoadStatus,
        state.selectedJudges,
        state.selectedStatuses,
        state.maxDurationFilter,
      ));
    }
  }

  void _onContestsToggledFav(
    ContestsEventToggledFav event,
    Emitter<ContestsState> emit,
  ) async {
    final List<Contest> newContests = [...state._contests];
    int contestIdx = newContests.indexWhere((c) => c.id == event.contest.id);

    // newContests[contestIdx] = event.toggledContest;
    newContests[contestIdx] = Contest.withToggledFav(event.contest);

    // log(
    //   '${state.onlineLoadStatus.name} ${state.cachedLoadStatus.name} '
    //   'for ${newContests[contestIdx].name} '
    //   'with ${newContests[contestIdx].isFavorite} fav status ',
    //   name: contestIdx.toString(),
    // );

    emit(ContestsStateLoaded(
      newContests,
      state.onlineLoadStatus,
      state.cachedLoadStatus,
      state.selectedJudges,
      state.selectedStatuses,
      state.maxDurationFilter,
    ));

    _contestsRepository.setFavoriteStatus(
      event.contest.id,
      event.newToggleStatus,
    );
  }

  void _onJudgeFilterToggled(
    ContestsEventJudgeFilterToggleRequested event,
    Emitter<ContestsState> emit,
  ) async {
    List<Contest> allContests = state._contests;

    emit(ContestsStateLoading(
      selectedJudges: state.selectedJudges,
      selectedStatuses: state.selectedStatuses,
      onlineLoadStatus: state.onlineLoadStatus,
      cachedLoadStatus: state.cachedLoadStatus,
      maxDurationFilter: state.maxDurationFilter,
    ));

    List<Judge> newSelectedJudges = [...state.selectedJudges];
    if (event.toggledValue) {
      newSelectedJudges.add(event.toggledJudge);
    } else {
      newSelectedJudges.remove(event.toggledJudge);
    }
    // log('new judge: $newSelectedJudges');

    if (allContests.isEmpty) {
      emit(ContestsStateAllLoadFailed(
        newSelectedJudges,
        state.selectedStatuses,
        state.maxDurationFilter,
      ));
      return;
    }

    emit(ContestsStateLoaded(
      allContests,
      state.onlineLoadStatus,
      state.cachedLoadStatus,
      newSelectedJudges,
      state.selectedStatuses,
      state.maxDurationFilter,
    ));
  }

  void _onStatusFilterToggled(
    ContestsEventStatusFilterToggleRequested event,
    Emitter<ContestsState> emit,
  ) {
    List<Contest> allContests = state._contests;

    emit(ContestsStateLoading(
      selectedJudges: state.selectedJudges,
      selectedStatuses: state.selectedStatuses,
      onlineLoadStatus: state.onlineLoadStatus,
      cachedLoadStatus: state.cachedLoadStatus,
      maxDurationFilter: state.maxDurationFilter,
    ));

    List<ContestStatus> newSelectedStatuses = [...state.selectedStatuses];
    if (event.toggledValue) {
      newSelectedStatuses.add(event.toggledStatus);
    } else {
      newSelectedStatuses.remove(event.toggledStatus);
    }

    if (allContests.isEmpty) {
      emit(ContestsStateAllLoadFailed(
        state.selectedJudges,
        newSelectedStatuses,
        state.maxDurationFilter,
      ));
      return;
    }

    emit(ContestsStateLoaded(
      allContests,
      state.onlineLoadStatus,
      state.cachedLoadStatus,
      state.selectedJudges,
      newSelectedStatuses,
      state.maxDurationFilter,
    ));
  }

  void _onMaxDurationFilterChanged(ContestsEventMaxDurationFilterChanged event,
      Emitter<ContestsState> emit) {
    List<Contest> allContests = state._contests;

    emit(ContestsStateLoading(
      selectedJudges: state.selectedJudges,
      selectedStatuses: state.selectedStatuses,
      onlineLoadStatus: state.onlineLoadStatus,
      cachedLoadStatus: state.cachedLoadStatus,
      maxDurationFilter: state.maxDurationFilter,
    ));

    if (allContests.isEmpty) {
      emit(ContestsStateAllLoadFailed(
        state.selectedJudges,
        state.selectedStatuses,
        event.newDurationFilter,
      ));
      return;
    }

    emit(ContestsStateLoaded(
      allContests,
      state.onlineLoadStatus,
      state.cachedLoadStatus,
      state.selectedJudges,
      state.selectedStatuses,
      event.newDurationFilter,
    ));
  }

  @override
  ContestsState? fromJson(Map<String, dynamic> json) {
    try {
      List<Judge> selectedJudges =
          (jsonDecode(json['selectedJudges']) as List<dynamic>)
              .map((e) => Judge.values.byName(e.toString()))
              .toList();

      List<ContestStatus> selectedStatuses =
          (jsonDecode(json['selectedStatuses']) as List<dynamic>)
              .map((e) => ContestStatus.values.byName(e.toString()))
              .toList();
      // log(selectedJudges.toString(), name: 'loaded statuses');

      return ContestsStateInitial(
        selectedJudges: selectedJudges,
        selectedStatuses: selectedStatuses,
        maxDurationFilter: MaxDurationFilter(
          Duration(seconds: int.parse(json['maxDurationSecs'])),
          json['maxDurationToggle'] == '1',
        ),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ContestsState state) {
    // log(jsonEncode(state.selectedJudges.map((judge) => judge.name).toList()),
    //     name: 'cached judges');
    return {
      'selectedJudges': jsonEncode(
        state.selectedJudges.map((judge) => judge.name).toList(),
      ),
      'selectedStatuses': jsonEncode(
        state.selectedStatuses.map((status) => status.name).toList(),
      ),
      'maxDurationSecs': state.maxDurationFilter.duration.inSeconds.toString(),
      'maxDurationToggle': state.maxDurationFilter.isOn ? '1' : '0',
    };
  }

  // @override
  // void onTransition(Transition<ContestsEvent, ContestsState> transition) {
  //   // TODO: implement onTransition
  //   super.onTransition(transition);
  //   log(
  //     '${transition.currentState.runtimeType} to ${transition.nextState.runtimeType}',
  //     name: 'transition',
  //   );

  // }
}
