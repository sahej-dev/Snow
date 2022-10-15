import 'package:flutter/material.dart';

import './material_dialog.dart';
import '../../constants/strings.dart';

class BatteryOptimizationExemptionDialog extends StatelessWidget {
  const BatteryOptimizationExemptionDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialDialog(
      title: const Text(SettingsConstants.notReceivingNotificationsHeading),
      content:
          const Text(SettingsConstants.notGettingNotificationsDialogContent),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text(
              SettingsConstants.notGettingNotificationsDialogCancelButton),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text(
              SettingsConstants.notGettingNotificationsDialogOkayButton),
        ),
      ],
    );
  }
}
