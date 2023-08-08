import 'dart:io';

import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:pencil/constants.dart';
import 'package:pencil/data/pencil/profile/profile.dart';
import 'package:pencil/data/pencil/profile/profiles_provider.dart';
import 'package:pencil/data/pencil/settings/settings_data.dart';
import 'package:pencil/data/pencil/settings/settings_provider.dart';
import 'package:pencil/data/minecraft/manifest/manifest_version.dart';
import 'package:pencil/data/minecraft/manifest/version_manifest_provider.dart';
import 'package:pencil/data/minecraft/version_type.dart';
import 'package:pencil/pages/profiles/profile_edit.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Profiles extends StatefulWidget {
  const Profiles({super.key});

  static void createProfile(BuildContext context) {
    VersionManifestProvider manifest = Provider.of<VersionManifestProvider>(context, listen: false);
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    ProfilesProvider profiles = Provider.of<ProfilesProvider>(context, listen: false);

    if (manifest.manifest == null) {
      showDialog(
          context: kBaseNavigatorKey.currentContext!,
          builder: (context) => AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                  title: const Text('Can\'t Create Profile'),
                  content: const Text(
                      'You can\'t create a profile right now because the version manifest isn\'t available yet. Please wait for a bit or restart Pencil.'),
                  actions: [
                    TextButton(
                        child: const Text('Confirm'),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ]));
      return;
    }

    List<ManifestVersion> toShow = [];
    List<String> available = [];
    for (ManifestVersion mfVersion in manifest.manifest!.versions) {
      available.add(mfVersion.id);
      if (mfVersion.type == VersionType.release && settings.data.launcher!.showReleases!) {
        toShow.add(mfVersion);
      }
      if (mfVersion.type == VersionType.snapshot && settings.data.launcher!.showSnapshots!) {
        toShow.add(mfVersion);
      }
      if ((mfVersion.type == VersionType.old_alpha || mfVersion.type == VersionType.old_beta) &&
          settings.data.launcher!.showHistorical!) {
        toShow.add(mfVersion);
      }
    }

    showDialog(
        context: kBaseNavigatorKey.currentContext!,
        builder: (context) {
          TextEditingController name = TextEditingController();
          TextEditingController version = TextEditingController();
          String? nameError;
          String? versionError;
          return StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                      title: const Text('Create Profile'),
                      insetPadding: const EdgeInsets.symmetric(horizontal: 250),
                      content: SizedBox(
                          width: 300,
                          child:
                              Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                            TextField(
                              decoration: InputDecoration(labelText: 'Name', errorText: nameError),
                              controller: name,
                            ),
                            DropdownMenu<String>(
                                controller: version,
                                width: 300,
                                menuHeight: 256,
                                label: const Text('Version'),
                                enableFilter: true,
                                errorText: versionError,
                                inputDecorationTheme: const InputDecorationTheme(border: UnderlineInputBorder()),
                                dropdownMenuEntries: [
                                  for (ManifestVersion mfVersion in toShow)
                                    DropdownMenuEntry<String>(value: mfVersion.id, label: mfVersion.id)
                                ])
                          ])),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Create'),
                          onPressed: () async {
                            setState(() {
                              nameError = null;
                              versionError = null;
                            });
                            if (name.text.length > 20 || name.text.isEmpty) {
                              setState(() {
                                nameError = 'Must be between 1 to 20 characters';
                              });
                              return;
                            }
                            if (!available.contains(version.text)) {
                              setState(() {
                                versionError = 'Version does not exist';
                              });
                              return;
                            }
                            Navigator.of(context).pop();
                            profiles.addProfile(Profile(
                                const Uuid().v4(),
                                name.text,
                                version.text,
                                'asset:assets/images/profiles/23.png',
                                DateTime.now(),
                                null,
                                QuickPlayMode.disabled,
                                null,
                                null,
                                null,
                                false,
                                '-Xmx2G -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M',
                                '',
                                AddonType.disabled,
                                null));
                            ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!)
                                .showSnackBar(SnackBar(content: Text('Created profile ${name.text}')));
                          },
                        )
                      ]));
        });
  }

  @override
  State<Profiles> createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ProfilesProvider profiles = Provider.of<ProfilesProvider>(context);
    SettingsProvider settings = Provider.of<SettingsProvider>(context);

    List<Profile> sortedProfiles = profiles.profiles.profiles.values.toList();
    if (settings.data.launcher!.profileSort == ProfileSortType.lastPlayed) {
      sortedProfiles.sort((a, b) => -a.lastUsed.compareTo(b.lastUsed));
    } else if (settings.data.launcher!.profileSort == ProfileSortType.name) {
      sortedProfiles.sort((a, b) => a.name.compareTo(b.name));
    }

    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(56),
            height: profiles.profiles.profiles.isEmpty ? MediaQuery.of(context).size.height : null,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (profiles.profiles.profiles.isEmpty)
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(bottom: 16), child: Text('Profiles', style: theme.textTheme.headlineLarge)))
              else
                Container(
                    margin: const EdgeInsets.only(bottom: 16), child: Text('Profiles', style: theme.textTheme.headlineLarge)),
              GridView.count(crossAxisCount: 3, shrinkWrap: true, childAspectRatio: 20 / 19, children: [
                for (Profile profile in sortedProfiles)
                  ProfileWidget(
                      profile: profile,
                      selected: profiles.profiles.selectedProfile == profile.uuid,
                      select: () {
                        profiles.profiles.selectedProfile = profile.uuid;
                        profiles.save();
                      })
              ]),
              if (profiles.profiles.profiles.isEmpty)
                Expanded(
                    child: Center(
                        child: Column(children: [
                  Container(
                      margin: const EdgeInsets.only(bottom: 8), child: const Icon(Icons.subdirectory_arrow_right, size: 72)),
                  const Text('Create a profile to start playing')
                ])))
            ])));
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key, required this.profile, required this.selected, required this.select});

  final Profile profile;
  final bool selected;
  final void Function() select;

  void deleteProfile(context) {
    ProfilesProvider profiles = Provider.of<ProfilesProvider>(context, listen: false);
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    showDialog(
        context: kBaseNavigatorKey.currentContext!,
        builder: (context) => AlertDialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                title: const Text('Are you sure?'),
                content: const Text('All data (including worlds) stored on this profile will be permanently deleted.'),
                actions: [
                  TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  TextButton(
                      child: const Text('Confirm'),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await profiles.removeProfile(profile.uuid);
                        Directory directory = Directory(path.join(settings.data.launcher!.profilesDirectory!, profile.uuid));
                        if (await directory.exists()) {
                          await directory.delete(recursive: true);
                        }
                        if (!profile.img.startsWith('asset:')) {
                          File file = File(profile.img);
                          if (await file.exists()) {
                            await file.delete();
                          }
                        }
                        ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!)
                            .showSnackBar(SnackBar(content: Text('Deleted profile ${profile.name}')));
                      })
                ]));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Card(
        elevation: selected ? 1 : 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Color.alphaBlend(theme.colorScheme.inversePrimary.withAlpha(selected ? 60 : 50), theme.scaffoldBackgroundColor),
        child: InkWell(
            customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onTap: select,
            onSecondaryTapUp: (details) {
              showContextMenu(
                  details.globalPosition,
                  context,
                  (context) => [
                        ListTile(
                            title: Text('Edit', style: theme.textTheme.titleMedium),
                            leading: const Icon(Icons.edit),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileEdit(profile: profile)));
                            }),
                        ListTile(
                            title: Text('Delete', style: theme.textTheme.titleMedium!.copyWith(color: theme.colorScheme.error)),
                            leading: Icon(Icons.delete, color: theme.colorScheme.error),
                            hoverColor: theme.colorScheme.error.withAlpha(20),
                            focusColor: theme.colorScheme.error.withAlpha(30),
                            splashColor: theme.colorScheme.error.withAlpha(30),
                            onTap: () {
                              Navigator.of(context).pop();
                              deleteProfile(context);
                            })
                      ],
                  10.0,
                  150.0);
            },
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: profile.img.startsWith('asset:')
                        ? Image.asset(profile.img.replaceAll('asset:', ''), fit: BoxFit.cover)
                        : Image.file(File(profile.img), fit: BoxFit.cover),
                  )),
              Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Text(profile.name, style: theme.textTheme.titleMedium!.copyWith(fontSize: 18, height: 1.1))),
                    Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Text(
                            profile.addon == null
                                ? profile.version
                                : '${profile.version} modded with ${profile.addon!.name} ${profile.addonVersion!}',
                            style: theme.textTheme.bodySmall)),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: FilledButton(
                            onPressed: profile.launching
                                ? null
                                : () {
                                    profile.play(kBaseNavigatorKey.currentContext!, false);
                                  },
                            child: Text(profile.launching ? '...' : 'Play')))
                  ]))
            ])));
  }
}
