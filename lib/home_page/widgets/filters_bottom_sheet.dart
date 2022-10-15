import 'dart:math' as math;
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:duration/duration.dart';
import 'package:duration_picker_dialog_box/duration_picker_dialog_box.dart';
import 'package:contests_repository/contests_repository.dart';

import '../../constants/ui.dart';
import '../../constants/strings.dart';
import '../../bloc/contests_bloc.dart';

class FiltersBottomSheet extends StatelessWidget {
  const FiltersBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kdefaultPadding * 2.5,
          vertical: kdefaultPadding,
        ),
        height: math.max(
          kdefaultBottomSheetMinHeight,
          MediaQuery.of(context).size.height * kdefaultBottomSheetScreenRatio,
        ),
        child: SingleChildScrollView(
          child: BlocBuilder<ContestsBloc, ContestsState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.only(top: kdefaultPadding)),
                  Text(
                    FiltersSheetConstants.judgeFilterTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Padding(padding: EdgeInsets.only(top: kdefaultPadding)),
                  Wrap(
                    spacing: kdefaultPadding * 1.5,
                    runSpacing: kdefaultPadding * 0.5,
                    children: [
                      for (Judge judge in state.allJudges)
                        FilterChip(
                          label: Text(
                            judge.name,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          selected: state.selectedJudges.contains(judge),
                          onSelected: (bool newVal) {
                            context
                                .read<ContestsBloc>()
                                .add(ContestsEventJudgeFilterToggleRequested(
                                  judge,
                                  newVal,
                                ));
                          },
                        )
                    ],
                  ),
                  const Padding(
                      padding: EdgeInsets.only(top: kdefaultPadding * 0.75)),
                  Divider(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const Padding(padding: EdgeInsets.only(top: kdefaultPadding)),
                  Text(
                    FiltersSheetConstants.contestDurationFilterTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Padding(padding: EdgeInsets.only(top: kdefaultPadding)),
                  Wrap(
                    spacing: kdefaultPadding * 1.5,
                    runSpacing: kdefaultPadding * 0.5,
                    children: [
                      for (ContestStatus status in state.allStatuses)
                        FilterChip(
                          label: Text(
                            status.name,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          selected: state.selectedStatuses.contains(status),
                          onSelected: (bool newVal) {
                            context
                                .read<ContestsBloc>()
                                .add(ContestsEventStatusFilterToggleRequested(
                                  status,
                                  newVal,
                                ));
                          },
                        )
                    ],
                  ),
                  const Padding(
                      padding: EdgeInsets.only(top: kdefaultPadding * 0.75)),
                  Divider(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const Padding(padding: EdgeInsets.only(top: kdefaultPadding)),
                  Text(
                    FiltersSheetConstants.otherFiltersTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Padding(padding: EdgeInsets.only(top: kdefaultPadding)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: Text(
                              '${FiltersSheetConstants.maxDurationFilterLabel}: '
                              '${state.maxDurationFilter.duration == MaxDurationFilter.infiniteDuration ? FiltersSheetConstants.infiniteTimeValueString : prettyDuration(state.maxDurationFilter.duration, abbreviated: false)}'),
                          selected: state.maxDurationFilter.isOn,
                          onSelected: (newVal) {
                            log(newVal.toString(), name: 'duration filter');
                            context
                                .read<ContestsBloc>()
                                .add(ContestsEventMaxDurationFilterChanged(
                                  MaxDurationFilter(
                                      state.maxDurationFilter.duration, newVal),
                                ));
                          },
                        ),
                        const Padding(
                            padding: EdgeInsets.only(left: kdefaultPadding)),
                        TextButton(
                          onPressed: () async {
                            Duration? newDur = await showDurationPicker(
                              context: context,
                              initialDuration: const Duration(seconds: 0),
                              defaultDuration:
                                  MaxDurationFilter.infiniteDuration,
                              durationPickerMode: DurationPickerMode.Hour,
                              showHead: true,
                            );

                            if (newDur != null) {
                              context.read<ContestsBloc>().add(
                                  ContestsEventMaxDurationFilterChanged(
                                      MaxDurationFilter(newDur,
                                          state.maxDurationFilter.isOn)));
                            }
                          },
                          child: const Text(
                            FiltersSheetConstants.filterEditButtonLabel,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Padding(
                      padding: EdgeInsets.only(top: kdefaultPadding * 0.75)),
                  Divider(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const Padding(padding: EdgeInsets.only(top: kdefaultPadding)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
