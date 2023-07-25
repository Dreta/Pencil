import 'package:flutter/material.dart';
import 'package:pencil/data/account/account.dart';
import 'package:pencil/data/account/accounts_provider.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class AccountsIndicator extends StatelessWidget {
  const AccountsIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AccountsProvider accounts = Provider.of<AccountsProvider>(context);
    Account? currentAccount = accounts.accounts.accounts[accounts.accounts.currentAccount];

    return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
            color: Colors.transparent,
            child: PopupMenuButton<String>(
              icon: currentAccount == null
                  ? const Icon(Icons.person)
                  : (currentAccount.type == AccountType.microsoft
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: FadeInImage(
                              placeholder: MemoryImage(kTransparentImage),
                              width: 32,
                              height: 32,
                              image: NetworkImage('https://api.mineatar.io/face/${currentAccount.uuid}?overlay=true')))
                      : SizedBox(
                          width: 32,
                          height: 32,
                          child: CircleAvatar(
                              radius: 16,
                              backgroundColor: theme.colorScheme.inversePrimary,
                              child: Text(accounts.accounts.accounts[currentAccount.uuid]!.characterName.characters.first
                                  .toUpperCase())))),
              tooltip: 'Switch Accounts',
              onSelected: (uuid) {
                accounts.accounts.currentAccount = uuid;
                accounts.save();
              },
              itemBuilder: (context) => [
                for (Account account in accounts.accounts.accounts.values)
                  PopupMenuItem<String>(
                      value: account.uuid,
                      child: ListTile(
                          leading: (account.type == AccountType.microsoft
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: FadeInImage(
                                      placeholder: MemoryImage(kTransparentImage),
                                      width: 32,
                                      height: 32,
                                      image: NetworkImage('https://api.mineatar.io/face/${account.uuid}?overlay=true')))
                              : CircleAvatar(
                                  radius: 16,
                                  backgroundColor: theme.colorScheme.inversePrimary,
                                  child: Text(account.characterName.characters.first.toUpperCase()))),
                          title: Text(account.characterName)))
              ],
            )));
  }
}
