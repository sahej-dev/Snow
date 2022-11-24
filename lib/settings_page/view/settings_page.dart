import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:optimize_battery/optimize_battery.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import '../widgets/widgets.dart';
import '../../constants/ui.dart';
import '../../constants/strings.dart';
import '../../bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(SettingsConstants.appBarTitle),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: kdefaultPadding * 2),
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      ThemeMode? newTheme = await showDialog(
                        context: context,
                        builder: (context) => ChoiceDialog<ThemeMode>(
                          options: const [
                            ThemeMode.light,
                            ThemeMode.dark,
                            ThemeMode.system,
                          ],
                          optionNames: const [
                            SettingsConstants.lightThemeName,
                            SettingsConstants.darkThemeName,
                            SettingsConstants.systemThemeName,
                          ],
                          initiallySelectedOption: state.themeMode,
                        ),
                      );

                      if (newTheme == null) return;

                      // ignore: use_build_context_synchronously
                      context
                          .read<SettingsBloc>()
                          .add(SettingsEventThemeModeChangeRequested(newTheme));
                    },
                    child: ListTile(
                      leading: const SettingsIcon(
                        Icons.color_lens_outlined,
                      ),
                      title: const Text(SettingsConstants.themeHeading),
                      subtitle: Text(state.themeModeName),
                    ),
                  ),
                  if (Platform.isAndroid)
                    ListTile(
                      leading: const SettingsIcon(MdiIcons.materialDesign),
                      title: const Text(SettingsConstants.useMaterial3Heading),
                      subtitle:
                          const Text(SettingsConstants.useMaterial3Subheading),
                      trailing: Switch.adaptive(
                        onChanged: (bool value) {
                          context
                              .read<SettingsBloc>()
                              .add(SettingsEventAccentSourceChangeRequested(
                                value
                                    ? AccentColorSource.material3
                                    : AccentColorSource.custom,
                              ));
                        },
                        value: state.accentColorSource ==
                            AccentColorSource.material3,
                      ),
                    ),
                  const ThemeSeedColorTile(),
                  InkWell(
                    onTap: () {
                      context
                          .read<AwesomeNotifications>()
                          .showNotificationConfigPage();
                    },
                    child: const ListTile(
                      leading: SettingsIcon(Icons.notifications_outlined),
                      title: Text(SettingsConstants.manageNotificationsHeading),
                      subtitle:
                          Text(SettingsConstants.manageNotificationsSubheading),
                    ),
                  ),
                  if (Platform.isAndroid)
                    InkWell(
                      onTap: () async {
                        if (await OptimizeBattery
                            .isIgnoringBatteryOptimizations()) {
                          OptimizeBattery.openBatteryOptimizationSettings();
                        } else {
                          bool? res = await showDialog(
                            context: context,
                            builder: (_) =>
                                const BatteryOptimizationExemptionDialog(),
                          );
                          if (res == null || res == false) return;
                          OptimizeBattery.stopOptimizingBatteryUsage();
                        }
                      },
                      child: const ListTile(
                        leading: SettingsIcon(Icons.dangerous_outlined),
                        title: Text(
                          SettingsConstants.notReceivingNotificationsHeading,
                        ),
                        subtitle: Text(SettingsConstants
                            .notReceivingNotificationsSubtitle),
                      ),
                    ),
                  InkWell(
                    onTap: () {
                      launchUrl(
                          Uri.parse(MetaDataConstants.githubBugReportLink),
                          mode: LaunchMode.externalApplication);
                    },
                    child: const ListTile(
                      leading: SettingsIcon(Icons.bug_report_outlined),
                      title: Text(SettingsConstants.bugReportHeading),
                      subtitle: Text(SettingsConstants.bugReportSubtitle),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launchUrl(
                          Uri.parse(MetaDataConstants.githubFeatureRequestLink),
                          mode: LaunchMode.externalApplication);
                    },
                    child: const ListTile(
                      leading: SettingsIcon(Icons.auto_fix_high),
                      title: Text(SettingsConstants.featureRequestHeading),
                      subtitle:
                          Text(SettingsConstants.featureRequestSubheading),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launchUrl(
                        Uri.parse(MetaDataConstants.githubHomeLink),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: const ListTile(
                      leading: SettingsIcon(MdiIcons.github),
                      title: Text(SettingsConstants.contributeHeading),
                      subtitle: Text(SettingsConstants.contributeSubtitle),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await Share.share(MetaDataConstants.shareText);
                    },
                    child: const ListTile(
                      leading: SettingsIcon(Icons.share),
                      title: Text(SettingsConstants.shareHeading),
                      subtitle: Text(SettingsConstants.shareSubtitle),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showLicensePage(
                        context: context,
                        applicationLegalese: LegalConstants.snowLicence,
                        // useRootNavigator: true,
                      );
                    },
                    child: const ListTile(
                      leading: SettingsIcon(Icons.copyright_outlined),
                      title: Text(SettingsConstants.legalHeading),
                      subtitle: Text(SettingsConstants.legalSubtitle),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const Padding(padding: EdgeInsets.only(top: kdefaultPadding)),
                  const MadeWithFooter(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
