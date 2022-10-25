import 'package:flutter/material.dart';

import './material_dialog.dart';
import '../../constants/strings.dart';

class ChoiceDialog<T extends Object> extends StatelessWidget {
  const ChoiceDialog({
    super.key,
    required this.options,
    required this.optionNames,
    required this.initiallySelectedOption,
  }) : assert(options.length == optionNames.length);

  final List<T> options;
  final List<String> optionNames;
  final T initiallySelectedOption;

  @override
  Widget build(BuildContext context) {
    return MaterialDialog(
      title: const Text(
        SettingsConstants.themeHeading,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < options.length; i++)
            RadioListTile(
              value: options[i],
              groupValue: initiallySelectedOption,
              title: Text(
                optionNames[i],
                style: Theme.of(context).textTheme.labelLarge,
              ),
              onChanged: (newTheme) {
                Navigator.pop(context, newTheme);
              },
            ),
          // InkWell(
          //   child: Text(optionNames[i]),
          // ),
        ],
      ),
    );
  }
}
