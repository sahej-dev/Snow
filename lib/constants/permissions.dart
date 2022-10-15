import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationsPermissions {
  static const List<NotificationPermission> permissions = [
    NotificationPermission.Alert,
    NotificationPermission.Sound,
    NotificationPermission.Badge,
    NotificationPermission.Vibration,
    NotificationPermission.Light,
    NotificationPermission.FullScreenIntent,
  ];
}
