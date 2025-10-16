import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mzflood/constants/app_creation_year.dart';
import 'package:mzflood/constants/urls.dart';
import 'package:mzflood/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppTile extends StatelessWidget {
  const AboutAppTile({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    TextStyle linkStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      decoration: TextDecoration.underline,
    );

    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
        Widget? applicationIcon = Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          clipBehavior: Clip.antiAlias,
          child: Image.asset('assets/images/app_icon.png', width: 64),
        );

        String authorName = AppLocalizations.of(context)!.authorName;
        String applicationLegalese = '\u{a9} $appCreationYear $authorName';

        final List<Widget> aboutBoxChildren = <Widget>[
          const SizedBox(height: 18),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: localizations.infoAppDescriptionStart),
                TextSpan(text: " "),
                TextSpan(
                  text: localizations.infoAppBasedOn,
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
          RichText(text: TextSpan(text: localizations.infoGameRules)),

          const SizedBox(height: 24),
          RichText(
            text: TextSpan(
              text: localizations.poweredByFlutter,
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

        if (snapshot.hasData) {
          return AboutListTile(
            applicationVersion:
                '${snapshot.data?.version} (${snapshot.data?.buildNumber})',
            applicationIcon: applicationIcon,
            applicationName: AppLocalizations.of(context)!.appTitle,
            icon: Icon(Icons.info_outline),
            applicationLegalese: applicationLegalese,
            aboutBoxChildren: aboutBoxChildren,
          );
        } else if (snapshot.hasError) {
          return AboutListTile(
            applicationName: AppLocalizations.of(context)!.appTitle,
            icon: Icon(Icons.info_outline),
            applicationIcon: applicationIcon,
            applicationLegalese: applicationLegalese,
            aboutBoxChildren: aboutBoxChildren,
          );
        } else {
          return ListTile(leading: CircularProgressIndicator());
        }
      },
    );
  }
}
