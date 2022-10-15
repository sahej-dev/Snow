import 'package:flutter/material.dart';

/// A Material3 [AlertDialog]
class MaterialDialog extends StatelessWidget {
  const MaterialDialog({
    super.key,
    this.title,
    required this.content,
    this.actions,
  });

  final Widget? title;
  final Widget content;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      elevation: 3,
      titleTextStyle: Theme.of(context)
          .textTheme
          .headlineSmall
          ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
      title: title,
      content: content,
      actions: actions,
    );
  }
}
