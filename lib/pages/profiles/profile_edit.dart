import 'dart:convert';
import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:pencil/constants.dart';
import 'package:pencil/data/account/account.dart';
import 'package:pencil/data/account/accounts_provider.dart';
import 'package:pencil/data/profile/profile.dart';
import 'package:pencil/data/profile/profiles_provider.dart';
import 'package:pencil/data/settings/settings_provider.dart';
import 'package:pencil/data/versions/manifest/manifest_version.dart';
import 'package:pencil/data/versions/manifest/version_manifest_provider.dart';
import 'package:pencil/data/versions/version_type.dart';
import 'package:provider/provider.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key, required this.profile});

  final Profile profile;

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  void changeProfileName() {
    ProfilesProvider profiles = Provider.of<ProfilesProvider>(context, listen: false);
    showDialog(
        context: kBaseNavigatorKey.currentContext!,
        builder: (context) {
          TextEditingController name = TextEditingController(text: widget.profile.name);
          String? nameError;
          return StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                      title: const Text('Change Profile Name'),
                      content: TextField(
                        decoration: InputDecoration(labelText: 'Profile Name', errorText: nameError),
                        controller: name,
                      ),
                      actions: [
                        TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        TextButton(
                            child: const Text('Confirm'),
                            onPressed: () {
                              setState(() {
                                nameError = null;
                              });
                              if (name.text.length > 20 || name.text.isEmpty) {
                                setState(() {
                                  nameError = 'Must be between 1 to 20 characters';
                                });
                                return;
                              }
                              widget.profile.name = name.text;
                              profiles.save();
                              ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!)
                                  .showSnackBar(SnackBar(content: Text('Changed profile\'s name to ${name.text}')));
                              Navigator.pop(context);
                            })
                      ]));
        });
  }

  void changeVersion() {
    VersionManifestProvider manifest = Provider.of<VersionManifestProvider>(context, listen: false);
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    ProfilesProvider profiles = Provider.of<ProfilesProvider>(context, listen: false);

    if (manifest.manifest == null) {
      showDialog(
          context: kBaseNavigatorKey.currentContext!,
          builder: (context) => AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                  title: const Text('Can\'t Change Version'),
                  content: const Text(
                      'You can\'t change the version right now because the version manifest isn\'t available yet. Please wait for a bit or restart Pencil.'),
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
          TextEditingController version = TextEditingController();
          String? versionError;
          return StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                      title: const Text('Change Version'),
                      insetPadding: const EdgeInsets.symmetric(horizontal: 250),
                      content: SizedBox(
                          width: 300,
                          child:
                              Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                            DropdownMenu<String>(
                                controller: version,
                                width: 300,
                                menuHeight: 256,
                                initialSelection: widget.profile.version,
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
                          child: const Text('Confirm'),
                          onPressed: () async {
                            setState(() {
                              versionError = null;
                            });
                            if (!available.contains(version.text)) {
                              setState(() {
                                versionError = 'Version does not exist';
                              });
                              return;
                            }
                            widget.profile.version = version.text;
                            profiles.save();
                            ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!)
                                .showSnackBar(SnackBar(content: Text('Changed profile\'s version to ${version.text}')));
                            Navigator.of(context).pop();
                          },
                        )
                      ]));
        });
  }

  void changeImage() async {
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    ProfilesProvider profiles = Provider.of<ProfilesProvider>(context, listen: false);
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image, dialogTitle: 'Choose Profile Image');
    if (result == null) {
      return;
    }
    File file = File(result.files[0].path!);
    Directory imagesDir = Directory(settings.data.launcher!.imagesDirectory!);
    if (!(await imagesDir.exists())) {
      await imagesDir.create(recursive: true);
    }
    File newFile = await file
        .copy(path.join(settings.data.launcher!.imagesDirectory!, 'p-${widget.profile.uuid}${path.extension(file.path)}'));
    widget.profile.img = newFile.absolute.path;
    profiles.save();
    ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!)
        .showSnackBar(const SnackBar(content: Text('Changed profile\'s image')));
  }

  void changeJVMArguments() {
    ProfilesProvider profiles = Provider.of<ProfilesProvider>(context, listen: false);
    showDialog(
        context: kBaseNavigatorKey.currentContext!,
        builder: (context) {
          TextEditingController args = TextEditingController(text: widget.profile.jvmArguments);
          return StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                      title: const Text('Change JVM Arguments'),
                      content: TextField(
                        decoration: InputDecoration(labelText: 'JVM Arguments'),
                        controller: args,
                      ),
                      actions: [
                        TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        TextButton(
                            child: const Text('Confirm'),
                            onPressed: () {
                              widget.profile.jvmArguments = args.text;
                              profiles.save();
                              ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!)
                                  .showSnackBar(const SnackBar(content: Text('Changed JVM arguments')));
                              Navigator.pop(context);
                            })
                      ]));
        });
  }

  void changeGameArguments() {
    ProfilesProvider profiles = Provider.of<ProfilesProvider>(context, listen: false);
    showDialog(
        context: kBaseNavigatorKey.currentContext!,
        builder: (context) {
          TextEditingController args = TextEditingController(text: widget.profile.gameArguments);
          return StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                      title: const Text('Change Game Arguments'),
                      content: TextField(
                        decoration: InputDecoration(labelText: 'Game Arguments'),
                        controller: args,
                      ),
                      actions: [
                        TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        TextButton(
                            child: const Text('Confirm'),
                            onPressed: () {
                              widget.profile.gameArguments = args.text;
                              profiles.save();
                              ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!)
                                  .showSnackBar(const SnackBar(content: Text('Changed game arguments')));
                              Navigator.pop(context);
                            })
                      ]));
        });
  }

  void changeResolution() {
    ProfilesProvider profiles = Provider.of<ProfilesProvider>(context, listen: false);
    showDialog(
        context: kBaseNavigatorKey.currentContext!,
        builder: (context) {
          TextEditingController width = TextEditingController(text: (widget.profile.resolutionWidth ?? '').toString());
          TextEditingController height = TextEditingController(text: (widget.profile.resolutionHeight ?? '').toString());
          String? widthError;
          String? heightError;
          return StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                      title: const Text('Change Resolution'),
                      content: Row(children: [
                        Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 16),
                            child: TextField(
                              decoration: InputDecoration(labelText: 'Width', errorText: widthError),
                              controller: width,
                            )),
                        const Text('×'),
                        Container(
                            width: 100,
                            margin: const EdgeInsets.only(left: 16),
                            child: TextField(
                              decoration: InputDecoration(labelText: 'Height', errorText: heightError),
                              controller: height,
                            ))
                      ]),
                      actions: [
                        TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        TextButton(
                            child: const Text('Confirm'),
                            onPressed: () {
                              setState(() {
                                widthError = null;
                                heightError = null;
                              });
                              if (width.text == '' && height.text == '') {
                                widget.profile.resolutionWidth = null;
                                widget.profile.resolutionHeight = null;
                                profiles.save();
                                ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!)
                                    .showSnackBar(const SnackBar(content: Text('Removed custom resolution')));
                                Navigator.pop(context);
                                return;
                              }
                              if (int.tryParse(width.text) == null) {
                                setState(() {
                                  widthError = 'Must be number';
                                });
                                return;
                              }
                              if (int.parse(width.text) <= 0) {
                                setState(() {
                                  widthError = 'Must be above 0';
                                });
                                return;
                              }
                              if (int.tryParse(height.text) == null) {
                                setState(() {
                                  heightError = 'Must be number';
                                });
                                return;
                              }
                              if (int.parse(height.text) <= 0) {
                                setState(() {
                                  heightError = 'Must be above 0';
                                });
                                return;
                              }
                              widget.profile.resolutionWidth = int.parse(width.text);
                              widget.profile.resolutionHeight = int.parse(height.text);
                              profiles.save();
                              ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!)
                                  .showSnackBar(SnackBar(content: Text('Changed resolution to ${width.text} × ${height.text}')));
                              Navigator.pop(context);
                            })
                      ]));
        });
  }

  void changeQuickPlay() async {
    ProfilesProvider profiles = Provider.of<ProfilesProvider>(context, listen: false);
    AccountsProvider accounts = Provider.of<AccountsProvider>(context, listen: false);
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    ThemeData theme = Theme.of(context);

    Account? selectedAccount =
        accounts.accounts.currentAccount == null ? null : accounts.accounts.accounts[accounts.accounts.currentAccount!]!;

    Map<String, String> saves = {};
    Directory directory = Directory(path.join(settings.data.launcher!.profilesDirectory!, widget.profile.uuid, 'saves'));
    if (await directory.exists()) {
      await for (FileSystemEntity file in directory.list()) {
        if (file is Directory) {
          List<String> pathParts = path.split(file.absolute.path);
          saves[file.absolute.path] = pathParts[pathParts.length - 1];
        }
      }
    }

    showDialog(
        context: kBaseNavigatorKey.currentContext!,
        builder: (context) {
          Map<QuickPlayMode, String> quickPlayMode = {
            QuickPlayMode.disabled: 'Disabled',
            QuickPlayMode.singleplayer: 'Singleplayer',
            QuickPlayMode.multiplayer: 'Multiplayer',
            QuickPlayMode.realms: 'Minecraft Realms'
          };
          QuickPlayMode mode = widget.profile.quickPlayMode;
          TextEditingController host = TextEditingController(
              text: (mode == QuickPlayMode.singleplayer
                      ? path.split(widget.profile.quickPlayHost!).last
                      : (widget.profile.quickPlayHost ?? ''))
                  .toString());
          String? hostPath = widget.profile.quickPlayHost;
          String? hostError;

          bool realmsLoading = false;
          bool realmsLoadError = false;
          Map<int, String>? realmsAvailable;

          return StatefulBuilder(builder: (context, setState) {
            if (mode == QuickPlayMode.realms &&
                realmsAvailable == null &&
                !realmsLoading &&
                selectedAccount != null &&
                selectedAccount.type == AccountType.microsoft) {
              setState(() {
                realmsLoading = true;
              });
              http.get(Uri.parse('https://pc.realms.minecraft.net/worlds'), headers: {
                'User-Agent': kUserAgent,
                'Cookie':
                    'sid=token:${selectedAccount.accessToken}:${selectedAccount.uuid};user=${selectedAccount.characterName};version=${widget.profile.version}'
              }).then((r) {
                realmsAvailable = {};
                for (Map<String, dynamic> server in jsonDecode(utf8.decode(r.bodyBytes))['servers']) {
                  realmsAvailable![server['id']] = server['name'];
                }
                setState(() {
                  realmsLoading = false;
                });
              }).catchError((_) {
                setState(() {
                  realmsLoading = false;
                  realmsLoadError = true;
                });
              });
            }
            return AlertDialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                title: const Text('Quick Play Options'),
                content: SizedBox(
                    width: 300,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          child: const Text('Quick Play will only take effect in version 23w14a (1.20) or later.')),
                      DropdownMenu<QuickPlayMode>(
                          width: 300,
                          menuHeight: 256,
                          label: const Text('Mode'),
                          initialSelection: mode,
                          onSelected: (value) {
                            setState(() {
                              mode = value ?? QuickPlayMode.disabled;
                            });
                          },
                          enableSearch: false,
                          inputDecorationTheme: const InputDecorationTheme(border: UnderlineInputBorder()),
                          dropdownMenuEntries: [
                            for (MapEntry<QuickPlayMode, String> entry in quickPlayMode.entries)
                              DropdownMenuEntry(value: entry.key, label: entry.value)
                          ]),
                      if (mode == QuickPlayMode.singleplayer)
                        DropdownMenu<String>(
                            controller: host,
                            width: 300,
                            menuHeight: 256,
                            initialSelection: hostPath,
                            onSelected: (value) {
                              setState(() {
                                hostPath = value;
                              });
                            },
                            label: const Text('Singleplayer World'),
                            enableFilter: true,
                            errorText: hostError,
                            inputDecorationTheme: const InputDecorationTheme(border: UnderlineInputBorder()),
                            dropdownMenuEntries: [
                              for (MapEntry<String, String> save in saves.entries)
                                DropdownMenuEntry(value: save.key, label: save.value)
                            ]),
                      if (mode == QuickPlayMode.multiplayer)
                        TextField(
                          decoration: InputDecoration(labelText: 'Server Address', errorText: hostError),
                          controller: host,
                        ),
                      if (mode == QuickPlayMode.realms)
                        if (selectedAccount == null || selectedAccount.type == AccountType.offline)
                          Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: const Text(
                                  'You must select a Microsoft account to view the Minecraft Realms available to you.'))
                        else if (realmsLoading)
                          Container(
                              margin: const EdgeInsets.only(top: 8), child: const Center(child: CircularProgressIndicator()))
                        else if (realmsLoadError)
                          Container(margin: const EdgeInsets.only(top: 8), child: Center(child: Icon(Icons.error, color: theme.colorScheme.error)))
                        else
                          DropdownMenu<int>(
                              controller: host,
                              width: 300,
                              menuHeight: 256,
                              initialSelection: hostPath == null ? null : int.parse(hostPath!),
                              onSelected: (value) {
                                setState(() {
                                  hostPath = value.toString();
                                });
                              },
                              label: const Text('Minecraft Realms'),
                              enableFilter: true,
                              errorText: hostError,
                              inputDecorationTheme: const InputDecorationTheme(border: UnderlineInputBorder()),
                              dropdownMenuEntries: [
                                for (MapEntry<int, String> realm in realmsAvailable!.entries)
                                  DropdownMenuEntry(value: realm.key, label: realm.value)
                              ]),
                    ])),
                actions: [
                  TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  TextButton(
                      child: const Text('Confirm'),
                      onPressed: () {
                        setState(() {
                          hostError = null;
                        });
                        if (mode == QuickPlayMode.singleplayer && !saves.containsValue(host.text)) {
                          setState(() {
                            hostError = 'Must be a world in this profile';
                          });
                          return;
                        }
                        if (mode == QuickPlayMode.realms && !(realmsAvailable ?? {}).containsValue(host.text)) {
                          setState(() {
                            hostError = 'Must be a Minecraft Realms you can access';
                          });
                          return;
                        }
                        widget.profile.quickPlayMode = mode;
                        widget.profile.quickPlayHost = (host.text.isEmpty || mode == QuickPlayMode.disabled)
                            ? null
                            : (mode == QuickPlayMode.multiplayer ? host.text : hostPath);
                        profiles.save();
                        ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!)
                            .showSnackBar(const SnackBar(content: Text('Changed Quick Play settings')));
                        Navigator.pop(context);
                      })
                ]);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ProfilesProvider profiles = Provider.of<ProfilesProvider>(context);

    return Scaffold(
        body: Stack(children: [
      Container(
          constraints: const BoxConstraints.expand(),
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(
                flex: 1,
                child: widget.profile.img.startsWith('asset:')
                    ? Image.asset(widget.profile.img.replaceAll('asset:', ''), fit: BoxFit.cover)
                    : Image.file(File(widget.profile.img), fit: BoxFit.cover)),
            Expanded(
                flex: 2,
                child: SingleChildScrollView(
                    child: Container(
                        padding: const EdgeInsets.all(56),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Text(widget.profile.name, style: theme.textTheme.headlineLarge)),
                          ListTile(
                              leading: const Icon(Icons.message),
                              title: Text('Name', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400)),
                              subtitle: Text(widget.profile.name,
                                  style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.secondary)),
                              onTap: () {
                                changeProfileName();
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                          ListTile(
                              leading: const Icon(Icons.update),
                              title: Text('Version', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400)),
                              subtitle: Text(widget.profile.version,
                                  style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.secondary)),
                              onTap: () {
                                changeVersion();
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                          ListTile(
                              leading: const Icon(Icons.numbers),
                              title:
                                  Text('Profile ID', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400)),
                              subtitle: Text(widget.profile.uuid,
                                  style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.secondary)),
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: widget.profile.uuid));
                                ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!)
                                    .showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                          ListTile(
                              leading: const Icon(Icons.image),
                              title: Text('Profile Image',
                                  style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400)),
                              onTap: () {
                                changeImage();
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                          Theme(
                              data: theme.copyWith(dividerColor: Colors.transparent),
                              child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  clipBehavior: Clip.antiAlias,
                                  margin: EdgeInsets.zero,
                                  color: Colors.transparent,
                                  child: ExpansionTile(
                                      leading: const Icon(Icons.settings),
                                      title: Text('Advanced',
                                          style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400)),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      children: [
                                        ListTile(
                                            leading: const Icon(Icons.code),
                                            title: Text('Custom JVM Arguments',
                                                style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400)),
                                            subtitle: Text(
                                                widget.profile.jvmArguments.length > 64
                                                    ? '${widget.profile.jvmArguments.substring(0, 61)}…'
                                                    : widget.profile.jvmArguments,
                                                style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.secondary)),
                                            onTap: () {
                                              changeJVMArguments();
                                            },
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                                        ListTile(
                                            leading: const Icon(Icons.code),
                                            title: Text('Custom Game Arguments',
                                                style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400)),
                                            subtitle: Text(
                                                widget.profile.gameArguments.isEmpty ? 'Unset' : widget.profile.gameArguments,
                                                style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.secondary)),
                                            onTap: () {
                                              changeGameArguments();
                                            },
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                                        ListTile(
                                            leading: const Icon(Icons.desktop_windows),
                                            title: Text('Custom Resolution',
                                                style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400)),
                                            subtitle: Text(
                                                (widget.profile.resolutionWidth != null &&
                                                        widget.profile.resolutionHeight != null)
                                                    ? '${widget.profile.resolutionWidth} × ${widget.profile.resolutionHeight}'
                                                    : 'Unset',
                                                style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.secondary)),
                                            onTap: () {
                                              changeResolution();
                                            },
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                                        SwitchListTile(
                                            secondary: const Icon(Icons.money_off),
                                            value: widget.profile.enabledDemoMode,
                                            onChanged: (value) {
                                              widget.profile.enabledDemoMode = value;
                                              profiles.save();
                                            },
                                            title: Text('Play in Demo Mode',
                                                style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400)),
                                            subtitle: Text('Only available in version 1.3 or later',
                                                style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.secondary)),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                                        ListTile(
                                            leading: const Icon(Icons.speed),
                                            title: Text('Quick Play',
                                                style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400)),
                                            subtitle: Text(
                                                (widget.profile.quickPlayMode == QuickPlayMode.disabled
                                                    ? 'Only available in version 23w14a (1.20) or later'
                                                    : '${{
                                                        QuickPlayMode.singleplayer: 'Singleplayer',
                                                        QuickPlayMode.multiplayer: 'Multiplayer',
                                                        QuickPlayMode.realms: 'Minecraft Realms'
                                                      }[widget.profile.quickPlayMode]}: ${widget.profile.quickPlayHost!.length > 64 ? '${widget.profile.quickPlayHost!.substring(0, 61)}…' : widget.profile.quickPlayHost}'),
                                                style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.secondary)),
                                            onTap: () {
                                              changeQuickPlay();
                                            },
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                                      ])))
                        ]))))
          ])),
      Positioned(
          left: 0,
          top: Platform.isMacOS ? 24 : 0,
          child: Container(
              margin: const EdgeInsets.all(8),
              child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }))),
      Positioned(top: 0, child: SizedBox(height: 32, width: MediaQuery.of(context).size.width, child: MoveWindow())),
      Positioned(
          top: 0,
          left: Platform.isMacOS ? 0 : null,
          right: !Platform.isMacOS ? 0 : null,
          child: Row(
              children: Platform.isMacOS
                  ? [CloseWindowButton(), MinimizeWindowButton(), MaximizeWindowButton()]
                  : [MinimizeWindowButton(), MaximizeWindowButton(), CloseWindowButton()]))
    ]));
  }
}
