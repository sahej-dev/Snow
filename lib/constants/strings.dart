class AppWideConstacts {
  static const String appTitle = 'Snow';
}

class HomePageConstants {
  static const String appBarTitle = 'All Contests';

  static const String bottomNavBarTitle = 'Home';

  static const String networkErrorTopMessage =
      'Unable to connect to the internet. Showing locally cached contests. '
      'Please check your network connection. Pull down to retry.';

  static const String noContestsFoundMessage =
      'Unable to fetch contests. Please ensure network connectivity and retry.';

  static const String unknowStateMessage =
      'App in unstable state. Please restart the app. If the problem persists than contact developers.';

  static const String allContestsFilteredOutMsg =
      'No contests found for the applied filters, try changing the filters.';

  static const String allLoadFailRetryButtonText = 'Retry Connection';
}

class FavoritesPageConstants {
  static const String appBarTitle = 'Favorite Contests';

  static const String bottomNavBarTitle = 'Favorites';

  static const String noFavoriteContestsMessage =
      'Looks like you have not added any contests to your favorites.';
}

class FiltersSheetConstants {
  static const String judgeFilterTitle = 'Judges';
  static const String contestDurationFilterTitle = 'Status';
  static const String otherFiltersTitle = 'Others';

  static const String maxDurationFilterLabel = 'maxDuration';
  static const String infiniteTimeValueString = '∞';
  static const String filterEditButtonLabel = 'Edit';
}

class NotificationConstants {
  static const String remindersGroupKey = 'reminders_key';
  static const String remindersGroupName = 'Reminders';

  static const String contestsRemindersChannelKey = 'contests_reminders_key';
  static const String contestsRemindersChannelName = 'Contests Reminders';
  static const String contestsRemindersChannelDesc =
      'Notification channel for sending reminder for upcoming contests';

  static const String notificationTitle = 'Contest Reminder';

  static const String askPermissionsTitle = 'Grant Notifications Access?';
  static const String askPermissionsText = 'Snow needs permission to send '
      'notifications reminding you about contests';
  static const String askPermissionsCancelBtnText = 'Cancel';
  static const String askPermissionsOkayBtnText = 'Okay';
}

class SettingsConstants {
  static const String appBarTitle = 'Settings';
  static const String bottomNavBarTitle = 'Settings';

  static const String themeHeading = 'App Theme';
  static const String systemThemeName = 'System Default';
  static const String darkThemeName = 'Kinda Dark';
  static const String lightThemeName = 'Clearly White';

  static const String useMaterial3Heading = 'Use Material You';
  static const String useMaterial3Subheading =
      'Only works if your device supports Material You';

  static const String accentColorHeading = 'Theme Seed Color';

  static const String manageNotificationsHeading = 'Manage Notifications';
  static const String manageNotificationsSubheading =
      'Allow/Disallow notifications';

  static const String notReceivingNotificationsHeading =
      'Not Getting Reminders?';
  static const String notReceivingNotificationsSubtitle =
      'Exempt Snow from battery optimization';
  static const String notGettingNotificationsDialogContent =
      'Battery saver mode'
      ' on your phone may be restricting notifications. Please \'Allow\' '
      'Snow to run without being restricted by battery saver mode and '
      'ensure that Snow is NOT optimized in battery optimizing settings.';
  static const String notGettingNotificationsDialogOkayButton = 'Okay';
  static const String notGettingNotificationsDialogCancelButton = 'Cancel';

  static const String bugReportHeading = 'Report Bug';
  static const String bugReportSubtitle =
      'If an unexpected error occurred then please report it here. '
      'If the problem persists try to \'Clear app data/cache\'.';

  static const String featureRequestHeading = 'Feature Request';
  static const String featureRequestSubheading =
      'Request a feature or improvement from the developers';

  static const String legalHeading = 'Legal';
  static const String legalSubtitle =
      'View licences of software(s) used by Snow';

  static const String contributeHeading = 'Support Snow';
  static const String contributeSubtitle =
      'You may leave a star and/or support development on GitHub';

  static const String shareHeading = 'Share';
  static const String shareSubtitle = 'Share the app with your friends';

  static const String madeWith = 'Made with immense ❤️ by ';
}

class MetaDataConstants {
  static const String myFirstName = 'Sahej';
  static const String myName = 'Sahej Singh';
  static const String myAbbrName = 'Sahej A. Singh';
  static const String myLegalName = 'Sahej Anand Singh';
  static const String myFullName = 'Sahej Singh Sarao';

  static const String personalWebsiteVisitLink = 'https://sahej.io';
  static const String personalWebsiteDisplayLink = 'sahej.io';

  static const String githubHomeLink = 'https://github.com/sahej-dev/Snow';
  static const String githubBugReportLink =
      'https://github.com/sahej-dev/Snow/issues/new?assignees=&labels=bug&template=bug_report.yaml&title=%5BBug%5D%3A+';
  static const String githubFeatureRequestLink =
      'https://github.com/sahej-dev/Snow/issues/new?assignees=&labels=enhancement&template=feature_request.yaml&title=%5BFR%5D%3A+';

  static const String shareText =
      'This is a great app which gives reminders of '
      'upcoming CP contests. Very helpful. Check it out at $githubHomeLink';
}

class LegalConstants {
  static String get snowLicence => '''MIT License

Copyright (c) ${DateTime.now().year} ${MetaDataConstants.myLegalName}

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.''';
}
