part of 'contests_bloc.dart';

@JsonSerializable()
class MaxDurationFilter extends Equatable {
  static const Duration infiniteDuration = Duration(days: 999999);

  final Duration duration;
  final bool isOn;

  const MaxDurationFilter(this.duration, this.isOn);

  @override
  List<Object?> get props => [duration, isOn];

  factory MaxDurationFilter.fromJson(Map<String, dynamic> json) =>
      _$MaxDurationFilterFromJson(json);

  Map<String, dynamic> toJson() => _$MaxDurationFilterToJson(this);
}

enum ContestsSortBy { nearestFirst, nearestLast, shorterFirst, longerFirst }

abstract class ContestsState extends Equatable {
  const ContestsState({
    required List<Contest> contests,
    required this.onlineLoadStatus,
    required this.cachedLoadStatus,
    required this.selectedJudges,
    required this.selectedStatuses,
    required this.maxDurationFilter,
    this.contestsSortBy = ContestsSortBy.nearestFirst,
  }) : _contests = contests;

  final List<Contest> _contests;
  final ContestsLoadStatus onlineLoadStatus;
  final ContestsLoadStatus cachedLoadStatus;
  final List<Judge> selectedJudges;
  final List<ContestStatus> selectedStatuses;
  final MaxDurationFilter maxDurationFilter;
  final ContestsSortBy contestsSortBy;

  final List<Judge> allJudges = const [
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
  ];

  final List<ContestStatus> allStatuses = const [
    ContestStatus.upcomingIn24Hrs,
    ContestStatus.upcoming,
    ContestStatus.onGoing,
  ];

  @override
  List<Object> get props => [
        onlineLoadStatus,
        cachedLoadStatus,
        selectedJudges,
        selectedStatuses,
        maxDurationFilter,
        contestsSortBy,
        _contests,
      ];

  List<Contest> get allContests => _contests;

  List<Contest> get filteredContests {
    Iterable<Contest> res = _contests.where((c) =>
        selectedJudges.contains(c.judge) &&
        selectedStatuses.contains(c.status));

    if (maxDurationFilter.isOn) {
      return res
          .where((c) => c.duration.compareTo(maxDurationFilter.duration) <= 0)
          .toList();
    }

    return res.toList();
  }

  List<Contest> get favoriteContests {
    return _contests.where((c) => c.isFavorite).toList();
  }
}

@JsonSerializable()
class ContestsStateInitial extends ContestsState {
  const ContestsStateInitial({
    List<Judge> selectedJudges = const [
      Judge.atCoder,
      Judge.codechef,
      Judge.codeforces,
      Judge.csAcademy,
      Judge.hackerEarth,
      Judge.hackerRank,
      Judge.kickStart,
      Judge.leetCode,
      Judge.topCoder,
      Judge.others,
    ],
    List<ContestStatus> selectedStatuses = const [
      ContestStatus.upcomingIn24Hrs,
      ContestStatus.upcoming,
      ContestStatus.onGoing,
    ],
    MaxDurationFilter maxDurationFilter =
        const MaxDurationFilter(MaxDurationFilter.infiniteDuration, false),
    ContestsSortBy contestsSortBy = ContestsSortBy.nearestFirst,
  }) : super(
          contests: const [],
          onlineLoadStatus: ContestsLoadStatus.unknown,
          cachedLoadStatus: ContestsLoadStatus.unknown,
          selectedJudges: selectedJudges,
          selectedStatuses: selectedStatuses,
          maxDurationFilter: maxDurationFilter,
          contestsSortBy: contestsSortBy,
        );
}

class ContestsStateLoading extends ContestsState {
  const ContestsStateLoading({
    required super.selectedJudges,
    required super.selectedStatuses,
    required MaxDurationFilter maxDurationFilter,
    required ContestsSortBy contestsSortBy,
    ContestsLoadStatus? onlineLoadStatus,
    ContestsLoadStatus? cachedLoadStatus,
  }) : super(
          contests: const [],
          onlineLoadStatus: onlineLoadStatus ?? ContestsLoadStatus.unknown,
          cachedLoadStatus: cachedLoadStatus ?? ContestsLoadStatus.unknown,
          maxDurationFilter: maxDurationFilter,
          contestsSortBy: contestsSortBy,
        );
}

class ContestsStateLoaded extends ContestsState {
  const ContestsStateLoaded(
    List<Contest> contests,
    ContestsLoadStatus onlineLoadStatus,
    ContestsLoadStatus cachedLoadStatus,
    List<Judge> selectedJudges,
    List<ContestStatus> selectedStatuses,
    MaxDurationFilter maxDurationFilter,
    ContestsSortBy contestsSortBy,
  ) : super(
          contests: contests,
          onlineLoadStatus: onlineLoadStatus,
          cachedLoadStatus: cachedLoadStatus,
          selectedJudges: selectedJudges,
          selectedStatuses: selectedStatuses,
          maxDurationFilter: maxDurationFilter,
          contestsSortBy: contestsSortBy,
        );

  List<Contest> get sortedAndFilteredContests {
    List<Contest> sortedContests = [...filteredContests];
    switch (contestsSortBy) {
      case ContestsSortBy.nearestFirst:
        sortedContests.sort(
          (a, b) => a.startDateTime.compareTo(b.startDateTime),
        );
        break;
      case ContestsSortBy.nearestLast:
        sortedContests.sort(
          (a, b) => b.startDateTime.compareTo(a.startDateTime),
        );
        break;
      case ContestsSortBy.shorterFirst:
        sortedContests.sort(
          (a, b) => a.duration.compareTo(b.duration),
        );
        break;
      case ContestsSortBy.longerFirst:
        sortedContests.sort(
          (a, b) => b.duration.compareTo(a.duration),
        );
        break;
      default:
    }

    return sortedContests;
  }
}

class ContestsStateAllLoadFailed extends ContestsState {
  const ContestsStateAllLoadFailed(
    List<Judge> selectedJudges,
    List<ContestStatus> selectedStatuses,
    MaxDurationFilter maxDurationFilter,
  ) : super(
          contests: const [],
          onlineLoadStatus: ContestsLoadStatus.fail,
          cachedLoadStatus: ContestsLoadStatus.fail,
          selectedJudges: selectedJudges,
          selectedStatuses: selectedStatuses,
          maxDurationFilter: maxDurationFilter,
        );
}
