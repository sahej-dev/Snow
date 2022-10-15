import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/ui.dart';
import './center_error_text.dart';
import '../bloc/contests_bloc.dart';
import '../constants/strings.dart';

class LoadFailedWidget extends StatelessWidget {
  const LoadFailedWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CenterErrorText(
          msg: HomePageConstants.noContestsFoundMessage,
        ),
        const Padding(padding: EdgeInsets.only(top: kdefaultPadding)),
        ElevatedButton(
          onPressed: () {
            context
                .read<ContestsBloc>()
                .add(const ContestsEventLoadRequested(false));
          },
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              Theme.of(context).colorScheme.primary,
            ),
            elevation: const MaterialStatePropertyAll(0),
            shadowColor: MaterialStatePropertyAll(
              Theme.of(context).colorScheme.shadow,
            ),
          ),
          child: Text(
            HomePageConstants.allLoadFailRetryButtonText,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ),
      ],
    );
  }
}
