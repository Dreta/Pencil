import 'package:json_annotation/json_annotation.dart';

part 'modrinth_user.g.dart';

@JsonSerializable()
class ModrinthUser {
  ModrinthUser(this.username, this.name, this.bio, this.id, this.avatarUrl, this.created, this.role, this.badges);

  final String username;
  final String? name;
  final String bio;
  final String id;
  final String avatarUrl;
  final DateTime created;
  final UserRole role;
  final int badges;

  factory ModrinthUser.fromJson(Map<String, dynamic> json) => _$ModrinthUserFromJson(json);

  Map<String, dynamic> toJson() => _$ModrinthUserToJson(this);
}

enum UserRole { admin, moderator, developer }
