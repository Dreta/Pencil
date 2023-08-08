import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pencil/constants.dart';
import 'package:pencil/data/pencil/account/account.dart';
import 'package:pencil/data/pencil/account/accounts_provider.dart';
import 'package:pencil/data/pencil/task/task.dart';
import 'package:pencil/data/pencil/task/tasks_provider.dart';
import 'package:pencil/pages/accounts/account_details.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:uuid/uuid.dart';

class Accounts extends StatefulWidget {
  const Accounts({super.key});

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  int _selectedIndex = 0;
  final GlobalKey _menuKey = GlobalKey();

  void createOfflineAccount() {
    AccountsProvider accounts = Provider.of<AccountsProvider>(context, listen: false);

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      showDialog(
          context: kBaseNavigatorKey.currentContext!,
          builder: (context) {
            TextEditingController username = TextEditingController();
            TextEditingController uuid = TextEditingController();
            uuid.text = const Uuid().v4().toString();
            String? usernameError;
            String? uuidError;
            return StatefulBuilder(
                builder: (context, setState) => AlertDialog(
                        title: const Text('Add Offline Account'),
                        insetPadding: const EdgeInsets.symmetric(horizontal: 250),
                        content: Column(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              child: const Text(
                                  'Offline accounts are stored locally, and cannot be used for logging in to servers with verification or Minecraft Realms.')),
                          TextField(
                            decoration: InputDecoration(labelText: 'Character Name', errorText: usernameError),
                            controller: username,
                          ),
                          TextField(
                            decoration: InputDecoration(labelText: 'UUID', errorText: uuidError),
                            controller: uuid,
                          )
                        ]),
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
                                usernameError = null;
                                uuidError = null;
                              });
                              if (username.text.length > 16 || username.text.length < 4) {
                                setState(() {
                                  usernameError = 'Must be 4 to 16 characters';
                                });
                                return;
                              }
                              for (String character in username.text.characters) {
                                if (!('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_'.contains(character))) {
                                  setState(() {
                                    usernameError = 'Can only contain alphabets, numbers and underscore';
                                  });
                                  return;
                                }
                              }
                              try {
                                UuidValue uuidValue = UuidValue.fromList(Uuid.parse(uuid.text));
                                Navigator.of(context).pop();
                                try {
                                  Account account = await accounts.createOfflineAccount(context, username.text, uuidValue);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!).showSnackBar(
                                        SnackBar(content: Text('Created offline account ${account.characterName}')));
                                  }
                                } catch (e1) {
                                  showDialog(
                                      context: kBaseNavigatorKey.currentContext!,
                                      builder: (context) => AlertDialog(
                                              insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                                              title: const Text('Failed to authenticate'),
                                              content: Text(e1.toString()),
                                              actions: [
                                                TextButton(
                                                    child: const Text('Confirm'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    })
                                              ]));
                                }
                              } catch (e) {
                                setState(() {
                                  uuidError = 'Incorrect format';
                                });
                              }
                            },
                          )
                        ]));
          });
    });
  }

  Future<void> createMicrosoftAccount() async {
    AccountsProvider accounts = Provider.of<AccountsProvider>(context, listen: false);
    TasksProvider tasks = Provider.of<TasksProvider>(context, listen: false);

    Webview window = await WebviewWindow.create(configuration: const CreateConfiguration(title: 'Login with Microsoft'));
    window.launch(
        'https://login.live.com/oauth20_authorize.srf?lw=1&fl=dob,easi2&xsup=1&prompt=select_account&client_id=00000000402B5328&response_type=code&scope=service%3A%3Auser.auth.xboxlive.com%3A%3AMBI_SSL&redirect_uri=https%3A%2F%2Flogin.live.com%2Foauth20_desktop.srf&nopa=2');
    window.addOnUrlRequestCallback((url) async {
      Uri uri = Uri.parse(url);
      if (uri.host == 'login.live.com' && uri.path == '/oauth20_desktop.srf') {
        if (uri.queryParameters.containsKey('code')) {
          window.close();
          ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!)
              .showSnackBar(const SnackBar(content: Text('Authenticating through Xbox Live...')));
          Task task =
              Task(name: 'Logging in through Xbox Live', type: TaskType.microsoftAuth, currentWork: 'Beginning authentication');
          tasks.addTask(task);
          try {
            Account account = await accounts.createMicrosoftAccount(context, uri.queryParameters['code']!, task, tasks);
            ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!)
                .showSnackBar(SnackBar(content: Text('Logged in to Minecraft as ${account.characterName}')));
          } catch (e) {
            showDialog(
                context: kBaseNavigatorKey.currentContext!,
                builder: (context) => AlertDialog(
                        insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                        title: const Text('Failed to authenticate'),
                        content: Text(e.toString()),
                        actions: [
                          TextButton(
                              child: const Text('Confirm'),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ]));
          } finally {
            tasks.removeTask(task);
          }
        }
        if (uri.queryParameters['error'] != null) {
          if (uri.queryParameters['error'] != 'access_denied' && context.mounted) {
            showDialog(
                context: kBaseNavigatorKey.currentContext!,
                builder: (context) => AlertDialog(
                        insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                        title: const Text('Failed to authenticate'),
                        content:
                            Text(uri.queryParameters['error_description'] ?? 'Unknown error: ${uri.queryParameters['error']}'),
                        actions: [
                          TextButton(
                              child: const Text('Confirm'),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ]));
          }
          window.close();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AccountsProvider accounts = Provider.of<AccountsProvider>(context);

    List<String> indexToUUID = [];
    for (Account account in accounts.accounts.accounts.values) {
      indexToUUID.add(account.uuid);
    }
    if (_selectedIndex >= indexToUUID.length) {
      _selectedIndex = indexToUUID.length - 1;
    }
    if (_selectedIndex < 0) {
      _selectedIndex = 0;
    }

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      NavigationDrawer(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(28, 16, 16, 16),
                child: Text('Accounts', style: theme.textTheme.headlineMedium)),
            if (accounts.accounts.accounts.isEmpty)
              const NavigationDrawerDestination(icon: Icon(Icons.person), label: Text('No Accounts')),
            for (String uuid in indexToUUID)
              NavigationDrawerDestination(
                  icon: accounts.accounts.accounts[uuid]!.reauthFailed
                      ? Icon(Icons.error, color: theme.colorScheme.error)
                      : (accounts.accounts.accounts[uuid]!.type == AccountType.microsoft
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: FadeInImage(
                                  placeholder: MemoryImage(kTransparentImage),
                                  width: 32,
                                  height: 32,
                                  image: NetworkImage('https://api.mineatar.io/face/$uuid?overlay=true')))
                          : CircleAvatar(
                              radius: 16,
                              backgroundColor: theme.colorScheme.inversePrimary,
                              child: Text(accounts.accounts.accounts[uuid]!.characterName.characters.first.toUpperCase()))),
                  label: Text(accounts.accounts.accounts[uuid]!.characterName,
                      style: TextStyle(color: accounts.accounts.accounts[uuid]!.reauthFailed ? theme.colorScheme.error : null))),
            Container(
                margin: const EdgeInsets.all(16),
                child: Align(
                    alignment: FractionalOffset.bottomLeft,
                    child: FloatingActionButton.extended(
                        onPressed: () {
                          (_menuKey.currentState as dynamic).showButtonMenu();
                        },
                        elevation: 0,
                        hoverElevation: 1,
                        focusElevation: 1,
                        label: PopupMenuButton(
                            key: _menuKey,
                            tooltip: '',
                            splashRadius: 0,
                            itemBuilder: (_) => [
                                  PopupMenuItem(
                                      onTap: () {
                                        createMicrosoftAccount();
                                      },
                                      child: const Text('Microsoft')),
                                  PopupMenuItem(
                                      onTap: () {
                                        createOfflineAccount();
                                      },
                                      child: const Text('Offline'))
                                ],
                            child: const Text('Add Account')),
                        icon: const Icon(Icons.add))))
          ]),
      if (accounts.accounts.accounts.isNotEmpty)
        Expanded(
            child: indexToUUID.map((uuid) => AccountDetails(account: accounts.accounts.accounts[uuid]!)).toList()[_selectedIndex])
    ]);
    ;
  }
}
