import 'package:json_annotation/json_annotation.dart';

part 'logging.g.dart';

@JsonSerializable()
class Logging {
  Logging(this.client);

  final ClientLogging client;

  factory Logging.fromJson(Map<String, dynamic> json) => _$LoggingFromJson(json);

  Map<String, dynamic> toJson() => _$LoggingToJson(this);
}

@JsonSerializable()
class ClientLogging {
  ClientLogging(this.argument, this.file, this.type);

  final String argument;
  final ClientLoggingFile file;
  String? type;

  factory ClientLogging.fromJson(Map<String, dynamic> json) => _$ClientLoggingFromJson(json);

  Map<String, dynamic> toJson() => _$ClientLoggingToJson(this);
}

@JsonSerializable()
class ClientLoggingFile {
  ClientLoggingFile(this.id, this.sha1, this.size, this.url);

  final String id;
  String? sha1;
  int? size;
  final String url;

  factory ClientLoggingFile.fromJson(Map<String, dynamic> json) => _$ClientLoggingFileFromJson(json);

  Map<String, dynamic> toJson() => _$ClientLoggingFileToJson(this);
}
