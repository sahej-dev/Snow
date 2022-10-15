import 'package:flutter/material.dart';

import '../../constants/ui.dart';

class SettingsIcon extends StatelessWidget {
  const SettingsIcon(this.icon, {super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: Theme.of(context).colorScheme.primary,
      size: (Theme.of(context).iconTheme.size ?? kdefaultIconSize),
    );
  }
}
