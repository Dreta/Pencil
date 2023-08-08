import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pencil/constants.dart';
import 'package:pencil/data/pencil/account/account.dart';
import 'package:pencil/data/pencil/account/accounts_provider.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key, required this.account});

  final Account account;

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  void copyUUID() {
    Clipboard.setData(ClipboardData(text: widget.account.uuid));
    ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!).showSnackBar(SnackBar(content: I18nText('generic.copyNotSensitive')));
  }

  void copyXUID() {
    Clipboard.setData(ClipboardData(text: widget.account.xuid!));
    ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!).showSnackBar(SnackBar(content: I18nText('generic.copyNotSensitive')));
  }

  void copyAccessToken() {
    Clipboard.setData(ClipboardData(text: widget.account.accessToken));
    ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!).showSnackBar(SnackBar(content: I18nText('generic.copySensitive')));
  }

  void changeOfflineUsername() {
    assert(widget.account.type == AccountType.offline);
    AccountsProvider accounts = Provider.of<AccountsProvider>(context, listen: false);
    showDialog(
        context: kBaseNavigatorKey.currentContext!,
        builder: (context) {
          TextEditingController username = TextEditingController(text: widget.account.characterName);
          String? usernameError;
          return StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                      title: I18nText('accountDetails.nameChange.title'),
                      content: TextField(
                        decoration: InputDecoration(
                            labelText: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'accountDetails.nameChange.field'),
                            errorText: usernameError),
                        controller: username,
                      ),
                      actions: [
                        TextButton(
                            child: I18nText('generic.cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        TextButton(
                            child: I18nText('generic.confirm'),
                            onPressed: () {
                              setState(() {
                                usernameError = null;
                              });
                              if (username.text.length > 16 || username.text.length < 4) {
                                setState(() {
                                  usernameError = FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'accountDetails.nameChange.lengthError');
                                });
                                return;
                              }
                              for (String character in username.text.characters) {
                                if (!('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_'.contains(character))) {
                                  setState(() {
                                    usernameError = FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'accountDetails.nameChange.charError');
                                  });
                                  return;
                                }
                              }
                              widget.account.username = username.text;
                              widget.account.characterName = username.text;
                              accounts.accounts.accounts[widget.account.uuid] = widget.account;
                              accounts.save();
                              ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!).showSnackBar(SnackBar(
                                  content:
                                      I18nText('accountDetails.nameChange.success', translationParams: {'name': username.text})));
                              Navigator.pop(context);
                            })
                      ]));
        });
  }

  void removeAccount() {
    AccountsProvider accounts = Provider.of<AccountsProvider>(context, listen: false);
    showDialog(
        context: kBaseNavigatorKey.currentContext!,
        builder: (context) => AlertDialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                title: I18nText('accountDetails.delete.title'),
                content: I18nText('accountDetails.delete.content'),
                actions: [
                  TextButton(
                      child: I18nText('generic.cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  TextButton(
                      child: I18nText('generic.confirm'),
                      onPressed: () {
                        accounts.removeAccount(widget.account.uuid).then((_) {
                          ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!).showSnackBar(SnackBar(
                              content: I18nText('accountDetails.delete.success',
                                  translationParams: {'name': widget.account.characterName})));
                        });
                        Navigator.pop(context);
                      })
                ]));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(56),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  child: Text(widget.account.characterName, style: theme.textTheme.headlineLarge)),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                    margin: const EdgeInsets.only(right: 24),
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      width: 139,
                      height: 312,
                      image: NetworkImage(
                          'https://api.mineatar.io/body/full/${widget.account.type == AccountType.microsoft ? widget.account.uuid : 'f498513c-e8c8-3773-be26-ecfc7ed5185d'}?scale=8&overlay=true'),
                      placeholder: MemoryImage(kTransparentImage),
                    )),
                Flexible(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (widget.account.reauthFailed)
                    Container(margin: const EdgeInsets.only(bottom: 4), child: I18nText('accountDetails.reauthRequired')),
                  ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'accountDetails.name'),
                          style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400)),
                      subtitle: Text(widget.account.characterName,
                          style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.secondary)),
                      trailing: widget.account.type == AccountType.microsoft ? const Icon(Icons.open_in_new) : null,
                      onTap: () {
                        if (widget.account.type == AccountType.microsoft) {
                          launchUrl(Uri.parse('https://www.minecraft.net/msaprofile'));
                        } else {
                          changeOfflineUsername();
                        }
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  if (widget.account.xboxGamertag != null)
                    ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'accountDetails.xblName'),
                            style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400)),
                        subtitle: Text(widget.account.xboxGamertag!,
                            style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.secondary)),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () {
                          launchUrl(Uri.parse('https://social.xbox.com/changegamertag'));
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  ListTile(
                      leading: const Icon(Icons.numbers),
                      onTap: copyUUID,
                      title: Text(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'accountDetails.uuid'),
                          style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400)),
                      subtitle: Text(widget.account.uuid,
                          style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.secondary)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  if (widget.account.xuid != null)
                    ListTile(
                        leading: const Icon(Icons.numbers),
                        onTap: copyXUID,
                        title: Text(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'accountDetails.xuid'),
                            style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400)),
                        subtitle: Text(widget.account.xuid!,
                            style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.secondary)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  if (widget.account.type == AccountType.microsoft)
                    ListTile(
                        leading: const Icon(Icons.key),
                        onTap: copyAccessToken,
                        title: Text(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'accountDetails.accessToken'),
                            style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400)),
                        subtitle: Text(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'accountDetails.copyAction'),
                            style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.secondary)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  ListTile(
                      leading: const Icon(Icons.coffee),
                      title: Text(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'accountDetails.accountType'),
                          style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400)),
                      subtitle: Text(
                          widget.account.type == AccountType.microsoft
                              ? FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'generic.accountTypes.microsoft')
                              : FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'generic.accountTypes.offline'),
                          style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.secondary)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  ListTile(
                    leading: Icon(Icons.delete, color: theme.colorScheme.error),
                    hoverColor: theme.colorScheme.error.withAlpha(20),
                    focusColor: theme.colorScheme.error.withAlpha(30),
                    splashColor: theme.colorScheme.error.withAlpha(30),
                    onTap: removeAccount,
                    title: Text(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'accountDetails.remove'),
                        style:
                            theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400, color: theme.colorScheme.error)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  )
                ]))
              ])
            ])));
  }
}
