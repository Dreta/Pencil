import 'package:json_annotation/json_annotation.dart';
import 'package:pencil/data/minecraft/rule.dart';

part 'arguments.g.dart';

@JsonSerializable()
class Arguments {
  Arguments(this.game, this.jvm);

  final List<dynamic> game; // String | PlatformArgument
  final List<dynamic> jvm; // String | PlatformArgument

  factory Arguments.fromJson(Map<String, dynamic> json) => _$ArgumentsFromJson(json);

  Map<String, dynamic> toJson() => _$ArgumentsToJson(this);
}

@JsonSerializable()
class PlatformArgument {
  PlatformArgument(this.rules, this.value);

  final List<Rule> rules;
  final dynamic value; // String | List<String>

  factory PlatformArgument.fromJson(Map<String, dynamic> json) => _$PlatformArgumentFromJson(json);

  Map<String, dynamic> toJson() => _$PlatformArgumentToJson(this);
}
