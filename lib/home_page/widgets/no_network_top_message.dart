import 'package:flutter/material.dart';

import '../../constants/ui.dart';
import '../../constants/strings.dart';

class NoNetworkTopMessage extends StatelessWidget {
  const NoNetworkTopMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kdefaultPadding,
          vertical: kdefaultPadding * 0.6,
        ),
        child: Text(
          HomePageConstants.networkErrorTopMessage,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
