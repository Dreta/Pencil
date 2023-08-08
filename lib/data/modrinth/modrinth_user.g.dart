// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modrinth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModrinthUser _$ModrinthUserFromJson(Map<String, dynamic> json) => ModrinthUser(
      json['username'] as String,
      json['name'] as String?,
      json['bio'] as String,
      json['id'] as String,
      json['avatarUrl'] as String,
      DateTime.parse(json['created'] as String),
      $enumDecode(_$UserRoleEnumMap, json['role']),
      json['badges'] as int,
    );

Map<String, dynamic> _$ModrinthUserToJson(ModrinthUser instance) =>
    <String, dynamic>{
      'username': instance.username,
      'name': instance.name,
      'bio': instance.bio,
      'id': instance.id,
      'avatarUrl': instance.avatarUrl,
      'created': instance.created.toIso8601String(),
      'role': _$UserRoleEnumMap[instance.role]!,
      'badges': instance.badges,
    };

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.moderator: 'moderator',
  UserRole.developer: 'developer',
};
