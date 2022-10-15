import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/ui.dart';
import '../../constants/strings.dart';
import '../../widgets/widgets.dart';
import '../../bloc/contests_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.symmetric(horizontal: kdefaultPadding),
      child: BlocBuilder<ContestsBloc, ContestsState>(
        builder: (context, state) {
          if (state is ContestsStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ContestsStateLoaded) {
            if (state.favoriteContests.isEmpty) {
              return const CenterErrorText(
                msg: FavoritesPageConstants.noFavoriteContestsMessage,
              );
            }
            return ListView.builder(
              itemCount: state.favoriteContests.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: kdefaultPadding * 0.6),
                  child: ContestTile(contest: state.favoriteContests[i]),
                );
              },
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
