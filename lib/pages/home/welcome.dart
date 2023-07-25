import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pencil/constants.dart';
import 'package:pencil/data/profile/profile.dart';
import 'package:pencil/data/profile/profiles_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ProfilesProvider profiles = Provider.of<ProfilesProvider>(context);
    Profile? selected = profiles.profiles.profiles[profiles.profiles.selectedProfile];

    return SizedBox(
        height: 260,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Scrollbar(
              controller: _controller,
              child: SizedBox(
                  height: 260,
                  child: ListView(controller: _controller, scrollDirection: Axis.horizontal, children: [
                    if (selected != null)
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 350,
                        child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            color: theme.colorScheme.inversePrimary.withAlpha(50),
                            child: InkWell(
                                customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                onTap: () async {
                                  if (!selected.launching) {
                                    selected.play(kBaseNavigatorKey.currentContext!, false);
                                  }
                                },
                                child:
                                Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                  SizedBox(
                                      width: 350,
                                      height: 150,
                                      child: ClipRRect(borderRadius: BorderRadius.circular(16), child: selected.img.startsWith('asset:')
                                          ? Image.asset(selected.img.replaceAll('asset:', ''), fit: BoxFit.cover)
                                          : Image.file(File(selected.img), fit: BoxFit.cover))),
                                  Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Container(
                                            margin: const EdgeInsets.only(bottom: 5),
                                            child: Text('Hop right back into the game', style: theme.textTheme.titleMedium!.copyWith(fontSize: 18, height: 1.1))),
                                        Text('Continue playing on the profile ${selected.name}.', style: theme.textTheme.bodySmall),
                                        Align(
                                            alignment: Alignment.bottomRight,
                                            child: FilledButton(
                                                onPressed: selected.launching
                                                    ? null
                                                    : () {
                                                  selected.play(kBaseNavigatorKey.currentContext!, false);
                                                },
                                                child: Text(selected.launching ? '...' : 'Play')))
                                      ])),
                                ])))),
                    WelcomeWidget(
                        url: 'https://example.org',
                        title: 'Welcome to Pencil',
                        subtitle: 'Learn more about how to easily get started.',
                        image: 'assets/images/styles/style-1.png')
                  ])))
        ]));
  }
}

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key, required this.url, required this.title, required this.subtitle, required this.image});

  final String url;
  final String title;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
        margin: const EdgeInsets.only(right: 10),
        width: 350,
        child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: theme.colorScheme.inversePrimary.withAlpha(50),
            child: InkWell(
                customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onTap: () async {
                  await launchUrl(Uri.parse(url));
                },
                child:
                    Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                      width: 350,
                      height: 150,
                      child: ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.asset(image, fit: BoxFit.cover))),
                  Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Text(title, style: theme.textTheme.titleMedium!.copyWith(fontSize: 18, height: 1.1))),
                        Text(subtitle, style: theme.textTheme.bodySmall)
                      ]))
                ]))));
  }
}
