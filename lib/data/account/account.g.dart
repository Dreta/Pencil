// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      json['username'] as String,
      json['characterName'] as String,
      json['uuid'] as String,
      json['xuid'] as String?,
      json['xboxGamertag'] as String?,
      json['accessToken'] as String,
      json['msAccessToken'] as String?,
      json['msRefreshToken'] as String?,
      json['xboxToken'] as String?,
      json['xboxUserHash'] as String?,
      json['xstsToken'] as String?,
      json['tokenExpireTime'] == null ? null : DateTime.parse(json['tokenExpireTime'] as String),
      json['reauthFailed'] as bool,
      $enumDecode(_$AccountTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'username': instance.username,
      'characterName': instance.characterName,
      'uuid': instance.uuid,
      'xuid': instance.xuid,
      'xboxGamertag': instance.xboxGamertag,
      'accessToken': instance.accessToken,
      'msAccessToken': instance.msAccessToken,
      'msRefreshToken': instance.msRefreshToken,
      'xboxToken': instance.xboxToken,
      'xboxUserHash': instance.xboxUserHash,
      'xstsToken': instance.xstsToken,
      'tokenExpireTime': instance.tokenExpireTime?.toIso8601String(),
      'reauthFailed': instance.reauthFailed,
      'type': _$AccountTypeEnumMap[instance.type]!,
    };

const _$AccountTypeEnumMap = {
  AccountType.offline: 'offline',
  AccountType.microsoft: 'microsoft',
};

Accounts _$AccountsFromJson(Map<String, dynamic> json) => Accounts(
      json['currentAccount'] as String?,
      (json['accounts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Account.fromJson(e as Map<String, dynamic>)),
          ) ??
          {},
    );

Map<String, dynamic> _$AccountsToJson(Accounts instance) => <String, dynamic>{
      'currentAccount': instance.currentAccount,
      'accounts': instance.accounts,
    };
