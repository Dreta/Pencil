import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pencil/constants.dart';
import 'package:pencil/data/account/accounts_provider.dart';
import 'package:pencil/data/profile/profiles_provider.dart';
import 'package:pencil/pages/accounts/accounts.dart' as accountsPage;
import 'package:pencil/pages/base/accounts_indicator.dart';
import 'package:pencil/pages/base/startup_tasks.dart';
import 'package:pencil/pages/base/tasks_indicator.dart';
import 'package:pencil/pages/home/home.dart';
import 'package:pencil/pages/profiles/profiles.dart';
import 'package:pencil/pages/settings/settings.dart';
import 'package:pencil/pages/tasks/tasks.dart';
import 'package:provider/provider.dart';

class PencilBase extends StatefulWidget {
  const PencilBase({super.key});

  @override
  State<PencilBase> createState() => _PencilBaseState();
}

class _PencilBaseState extends State<PencilBase> {
  int _selectedPage = 0;
  bool _showingTasks = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      StartupTasks.checkWebviewAvailability(context);
      StartupTasks.refreshAccounts(context);
      StartupTasks.downloadVersionManifest(context);
      StartupTasks.downloadJava(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ProfilesProvider profiles = Provider.of<ProfilesProvider>(context);
    AccountsProvider accounts = Provider.of<AccountsProvider>(context);

    return Scaffold(
        key: kBaseScaffoldKey,
        floatingActionButton: _selectedPage == 1
            ? FloatingActionButton.extended(
                icon: const Icon(Icons.add),
                label: const Text('Create Profile'),
                onPressed: () {
                  Profiles.createProfile(context);
                },
              )
            : ((profiles.profiles.selectedProfile != null && accounts.accounts.currentAccount != null)
                ? FloatingActionButton.extended(
                    icon: const Icon(Icons.gamepad),
                    label: profiles.profiles.profiles[profiles.profiles.selectedProfile!]!.launching
                        ? const Text('Playing...')
                        : const Text('Play'),
                    onPressed: () {
                      profiles.profiles.profiles[profiles.profiles.selectedProfile!]!
                          .play(kBaseNavigatorKey.currentContext!, false);
                    })
                : null),
        body: Stack(children: [
          SafeArea(
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(children: [
              NavigationRail(
                  selectedIndex: _selectedPage,
                  groupAlignment: -1,
                  onDestinationSelected: (index) {
                    setState(() {
                      _showingTasks = false;
                      _selectedPage = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: theme.colorScheme.inversePrimary.withAlpha(30),
                  leading: const SizedBox(height: 16),
                  destinations: const [
                    NavigationRailDestination(
                        icon: Icon(Icons.feed_outlined), selectedIcon: Icon(Icons.feed), label: Text('Home')),
                    NavigationRailDestination(
                        icon: Icon(Icons.gamepad_outlined), selectedIcon: Icon(Icons.gamepad), label: Text('Profiles')),
                    NavigationRailDestination(
                        icon: Icon(Icons.mode_standby_outlined), selectedIcon: Icon(Icons.mode_standby), label: Text('Mods')),
                    NavigationRailDestination(
                        icon: Icon(Icons.person_outlined), selectedIcon: Icon(Icons.person), label: Text('Accounts')),
                    NavigationRailDestination(
                        icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: Text('Settings'))
                  ]),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: TasksIndicator(showTasks: () {
                          setState(() {
                            _showingTasks = true;
                          });
                        })),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(margin: const EdgeInsets.only(bottom: 16), child: const AccountsIndicator()))
                  ]))
            ]),
            Expanded(
                child: _showingTasks
                    ? Tasks(hideTasks: () {
                        setState(() {
                          _showingTasks = false;
                        });
                      })
                    : const [Home(), Profiles(), Placeholder(), accountsPage.Accounts(), Settings()][_selectedPage])
          ])),
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
