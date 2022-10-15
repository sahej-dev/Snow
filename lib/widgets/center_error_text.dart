import 'package:flutter/material.dart';

import '../constants/ui.dart';

class CenterErrorText extends StatelessWidget {
  const CenterErrorText({
    Key? key,
    required this.msg,
  }) : super(key: key);

  final String msg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kdefaultPadding),
      child: Center(
        child: Text(
          msg,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
