import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contests_repository/contests_repository.dart';

import '../widgets/widgets.dart';
import '../../constants/ui.dart';
import '../../widgets/widgets.dart';
import '../../constants/strings.dart';
import '../../bloc/contests_bloc.dart';
import '../../bloc/notifications_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomePageView();
  }
}

bool _notifCleanUpDone = false;
bool _shownPermissionsDialog = false;

class HomePageView extends StatelessWidget {
  const HomePageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!_shownPermissionsDialog) {
      _shownPermissionsDialog = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.read<NotificationsBloc>().state.firstLaunch) {
          showDialog(
            context: context,
            builder: (builder) => const NotificationsPermissionsPopup(),
          );
        }
      });
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kdefaultPadding),
      color: Theme.of(context).colorScheme.background,
      child: BlocBuilder<ContestsBloc, ContestsState>(
        builder: (context, state) {
          // log('builder called');
          // log(state.runtimeType.toString());
          if (state is ContestsStateLoading) {
            // log('loading!!!');
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ContestsStateLoaded) {
            if (!_notifCleanUpDone) {
              _notifCleanUpDone = true;
              context
                  .read<NotificationsBloc>()
                  .add(NotificationsEventExpiredCleanup(state.allContests));
            }
            if (state.filteredContests.isEmpty) {
              return const CenterErrorText(
                msg: HomePageConstants.allContestsFilteredOutMsg,
              );
            }
            // log('selector built');
            final List<Contest> sortedAndFilteredContests =
                state.sortedAndFilteredContests;
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<ContestsBloc>()
                    .add(const ContestsEventLoadRequested(true));
              },
              child: ListView.builder(
                itemCount: state.onlineLoadStatus == ContestsLoadStatus.success
                    ? sortedAndFilteredContests.length
                    : sortedAndFilteredContests.length + 1,
                itemBuilder: (context, i) {
                  int idx = i;
                  if (idx == 0 &&
                      state.onlineLoadStatus != ContestsLoadStatus.success) {
                    return const NoNetworkTopMessage();
                  }

                  if (state.onlineLoadStatus != ContestsLoadStatus.success) {
                    idx -= 1;
                  }
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: kdefaultPadding * 0.6),
                    child: ContestTile(contest: sortedAndFilteredContests[idx]),
                  );
                },
              ),
            );
          } else if (state is ContestsStateAllLoadFailed) {
            return const LoadFailedWidget();
          } else {
            return const CenterErrorText(
              msg: HomePageConstants.unknowStateMessage,
            );
          }
        },
      ),
    );
  }
}
