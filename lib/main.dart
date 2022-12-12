import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:contests_repository/contests_repository.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import './app.dart';
import './constants/strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications notificationsPlugin = AwesomeNotifications();
  notificationsPlugin.initialize(
    null, // null img, so default icon used as notif img
    [
      NotificationChannel(
        channelGroupKey: NotificationConstants.remindersGroupKey,
        channelKey: NotificationConstants.contestsRemindersChannelKey,
        channelName: NotificationConstants.contestsRemindersChannelName,
        channelDescription: NotificationConstants.contestsRemindersChannelDesc,
      )
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: NotificationConstants.remindersGroupKey,
        channelGroupName: NotificationConstants.remindersGroupName,
      )
    ],
    debug: true,
  );

  AwesomeNotifications().setListeners(
    onActionReceivedMethod: NotificationsListeners.doNothing,
    onNotificationCreatedMethod: NotificationsListeners.doNothing,
    onNotificationDisplayedMethod: NotificationsListeners.doNothing,
    onDismissActionReceivedMethod: NotificationsListeners.doNothing,
  );

  // bool permissionsGranted = await notificationsPlugin.isNotificationAllowed();
  // if (!permissionsGranted) {
  //   notificationsPlugin.requestPermissionToSendNotifications(
  //     permissions: NotificationsPermissions.permissions,
  //   );
  // }

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  ContestsRepository contestsRepository = ContestsRepository();

  runApp(SnowApp(
    contestsRepository: contestsRepository,
    notificationsPlugin: notificationsPlugin,
  ));
}

class NotificationsListeners {
  @pragma("vm:entry-point")
  static Future<void> doNothing(
      ReceivedNotification receivedNotification) async {}
}
