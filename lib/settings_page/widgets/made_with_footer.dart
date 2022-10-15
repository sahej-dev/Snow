import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../constants/ui.dart';
import '../../constants/strings.dart';

class MadeWithFooter extends StatelessWidget {
  const MadeWithFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        launchUrl(
          Uri.parse(MetaDataConstants.personalWebsiteVisitLink),
          mode: LaunchMode.externalApplication,
        );
      },
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              text: SettingsConstants.madeWith,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            textAlign: TextAlign.center,
          ),
          RichText(
            text: TextSpan(
              text: MetaDataConstants.myFullName,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: kdefaultPadding * 0.5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                MetaDataConstants.personalWebsiteDisplayLink,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                textAlign: TextAlign.center,
              ),
              const Padding(
                padding: EdgeInsets.only(right: kdefaultPadding * 0.5),
              ),
              Icon(
                Icons.open_in_new_rounded,
                size: Theme.of(context).textTheme.bodyLarge?.fontSize,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
