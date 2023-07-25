import 'package:json_annotation/json_annotation.dart';

part 'downloads.g.dart';

@JsonSerializable()
class Downloads {
  Downloads(this.client, this.client_mappings, this.server, this.server_mappings);

  final LauncherDownload client;
  LauncherDownload? client_mappings;
  LauncherDownload? server;
  LauncherDownload? server_mappings;

  factory Downloads.fromJson(Map<String, dynamic> json) => _$DownloadsFromJson(json);

  Map<String, dynamic> toJson() => _$DownloadsToJson(this);
}

@JsonSerializable()
class LauncherDownload {
  LauncherDownload(this.sha1, this.size, this.url);

  String? sha1;
  int? size;
  final String url;

  factory LauncherDownload.fromJson(Map<String, dynamic> json) => _$LauncherDownloadFromJson(json);

  Map<String, dynamic> toJson() => _$LauncherDownloadToJson(this);
}
