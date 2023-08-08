import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

enum AccountType { offline, microsoft }

@JsonSerializable()
class Account {
  Account(this.username, this.characterName, this.uuid, this.xuid, this.xboxGamertag, this.accessToken, this.msAccessToken,
      this.msRefreshToken, this.xboxToken, this.xboxUserHash, this.xstsToken, this.tokenExpireTime, this.reauthFailed, this.type);

  String username;
  String characterName;
  String uuid;
  String? xuid;
  String? xboxGamertag;

  String accessToken;
  String? msAccessToken;
  String? msRefreshToken;
  String? xboxToken;
  String? xboxUserHash;
  String? xstsToken;
  DateTime? tokenExpireTime;
  bool reauthFailed;

  AccountType type;

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}

@JsonSerializable()
class Accounts {
  Accounts(this.currentAccount, this.accounts);

  String? currentAccount; // uuid
  @JsonKey(defaultValue: {})
  Map<String, Account> accounts; // uuid to account

  factory Accounts.fromJson(Map<String, dynamic> json) => _$AccountsFromJson(json);

  Map<String, dynamic> toJson() => _$AccountsToJson(this);
}
