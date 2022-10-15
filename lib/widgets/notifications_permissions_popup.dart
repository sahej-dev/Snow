import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:snow/bloc/contests_bloc.dart';

import '../constants/ui.dart';
import '../constants/strings.dart';
import '../constants/permissions.dart';
import '../bloc/notifications_bloc.dart';

class NotificationsPermissionsPopup extends StatelessWidget {
  const NotificationsPermissionsPopup({super.key});

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
      contentTextStyle: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      icon: const Icon(
        Icons.warning_amber_rounded,
        size: kdefaultIconSize * 1.5,
      ),
      iconColor: Theme.of(context).colorScheme.secondary,
      title: const Text(
        NotificationConstants.askPermissionsTitle,
      ),
      content: const Text(
        NotificationConstants.askPermissionsText,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(NotificationConstants.askPermissionsCancelBtnText),
        ),
        TextButton(
          onPressed: () async {
            context
                .read<AwesomeNotifications>()
                .requestPermissionToSendNotifications(
                  permissions: NotificationsPermissions.permissions,
                );

            context
                .read<NotificationsBloc>()
                .add(NotificationsEventTrySchedulingUnscheduled(
                  context.read<ContestsBloc>().state.favoriteContests,
                ));

            Navigator.pop(context);
          },
          child: const Text(NotificationConstants.askPermissionsOkayBtnText),
        ),
      ],
    );
  }
}
