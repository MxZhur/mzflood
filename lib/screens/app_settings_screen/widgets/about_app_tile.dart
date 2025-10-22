import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '/constants/app_creation_year.dart';
import '/constants/urls.dart';
import '/l10n/app_localizations.dart';

class AboutAppTile extends StatelessWidget {
  const AboutAppTile({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;

    final linkStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      decoration: TextDecoration.underline,
    );

    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (_, snapshot) {
        Widget applicationIcon = Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          clipBehavior: Clip.antiAlias,
          child: Image.asset('assets/images/app_icon.png', width: 64),
        );

        final authorName = i18n.authorName;
        final applicationLegalese = '\u{a9} $appCreationYear $authorName';

        final aboutBoxChildren = <Widget>[
          const SizedBox(height: 18),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: i18n.infoAppDescriptionStart),
                TextSpan(text: ' '),
                TextSpan(
                  text: i18n.infoAppBasedOn,
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async =>
                        await canLaunchUrl(Uri.parse(originalGameUrl)).then(
                          (value) async =>
                              await launchUrl(Uri.parse(originalGameUrl)),
                        ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),
          RichText(text: TextSpan(text: i18n.infoGameRules)),

          const SizedBox(height: 24),
          RichText(
            text: TextSpan(
              text: i18n.poweredByFlutter,
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () async =>
                    await canLaunchUrl(
                      Uri.parse(flutterOfficialWebsiteUrl),
                    ).then(
                      (value) async =>
                          await launchUrl(Uri.parse(flutterOfficialWebsiteUrl)),
                    ),
            ),
          ),
        ];

        if (!snapshot.hasData && !snapshot.hasError) {
          return ListTile(leading: CircularProgressIndicator());
        }

        return AboutListTile(
          applicationVersion: snapshot.hasData
              ? '${snapshot.data?.version} (${snapshot.data?.buildNumber})'
              : null,
          applicationIcon: applicationIcon,
          applicationName: i18n.appTitle,
          icon: const Icon(Icons.info_outline),
          applicationLegalese: applicationLegalese,
          aboutBoxChildren: aboutBoxChildren,
        );
      },
    );
  }
}
