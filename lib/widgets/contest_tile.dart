import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:duration/duration.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:contests_repository/contests_repository.dart';

import '../constants/ui.dart';
import '../bloc/contests_bloc.dart';
import '../bloc/notifications_bloc.dart';

class ContestTile extends StatelessWidget {
  const ContestTile({
    Key? key,
    required this.contest,
  }) : super(key: key);

  final Contest contest;

  void _launchContestLink(final Uri? link) async {
    if (link != null) {
      await launchUrl(
        link,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    log('built', name: 'contest_tile');
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kdefaultBorderRadius),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kdefaultPadding,
          vertical: kdefaultPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        splashColor:
                            Theme.of(context).colorScheme.surfaceVariant,
                        onTap: () async => _launchContestLink(contest.link),
                        child: Text(
                          contest.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                          softWrap: true,
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.only(top: kdefaultPadding)),
                      Text(
                        '${contest.judge.name} | ${prettyDuration(contest.duration, abbreviated: true)}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color:
                                Theme.of(context).textTheme.bodySmall?.color),
                      )
                    ],
                  ),
                ),
                IconButton(
                  enableFeedback: true,
                  onPressed: () {
                    bool currFavStatus = contest.isFavorite;
                    context.read<ContestsBloc>().add(
                          ContestsEventToggledFav(contest, !currFavStatus),
                        );
                    if (currFavStatus) {
                      context.read<NotificationsBloc>().add(
                            NotificationsEventContestCancellationRequested(
                                contest),
                          );
                    } else {
                      context.read<NotificationsBloc>().add(
                            NotificationsEventContestSchedulingRequested(
                                contest),
                          );
                    }
                  },
                  icon: Icon(
                    contest.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: contest.isFavorite
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    size:
                        (Theme.of(context).iconTheme.size ?? kdefaultIconSize) *
                            1.35,
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: kdefaultPadding * 2)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: kdefaultPadding / 1.5),
                    ),
                    Text(
                      formatDate(
                        contest.startDateTime.toLocal(),
                        [D, ', ', M, ' ', dd],
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: kdefaultPadding / 1.5),
                    ),
                    Text(
                      formatDate(
                        contest.startDateTime.toLocal(),
                        [hh, ':', nn, ' ', am],
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            const Padding(
                padding: EdgeInsets.only(top: kdefaultPadding * 0.75)),
          ],
        ),
      ),
    );
  }
}
