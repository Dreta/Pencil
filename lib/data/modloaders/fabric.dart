import 'package:json_annotation/json_annotation.dart';

part 'fabric.g.dart';

@JsonSerializable()
class FabricCompatibleLoader {
  FabricCompatibleLoader(this.loader, this.hashed, this.intermediary, this.launcherMeta);

  FabricVersion loader;
  FabricVersion? hashed;
  FabricVersion? intermediary;
  FabricLauncherMeta launcherMeta;

  factory FabricCompatibleLoader.fromJson(Map<String, dynamic> json) => _$FabricCompatibleLoaderFromJson(json);

  Map<String, dynamic> toJson() => _$FabricCompatibleLoaderToJson(this);
}

@JsonSerializable()
class FabricLibrary {
  FabricLibrary(this.name, this.url);
  
  String name;
  String url;
  
  factory FabricLibrary.fromJson(Map<String, dynamic> json) => _$FabricLibraryFromJson(json);

  Map<String, dynamic> toJson() => _$FabricLibraryToJson(this);
}

@JsonSerializable()
class FabricLauncherMeta {
  FabricLauncherMeta(this.version, this.libraries, this.mainClass);

  int version;
  FabricLibraries libraries;
  FabricMainClass mainClass;
  
  factory FabricLauncherMeta.fromJson(Map<String, dynamic> json) => _$FabricLauncherMetaFromJson(json);

  Map<String, dynamic> toJson() => _$FabricLauncherMetaToJson(this);
}

@JsonSerializable()
class FabricLibraries {
  FabricLibraries(this.client, this.common, this.server);

  List<FabricLibrary> client;
  List<FabricLibrary> common;
  List<FabricLibrary> server;

  factory FabricLibraries.fromJson(Map<String, dynamic> json) => _$FabricLibrariesFromJson(json);

  Map<String, dynamic> toJson() => _$FabricLibrariesToJson(this);
}

@JsonSerializable()
class FabricMainClass {
  FabricMainClass(this.client, this.server, this.serverLauncher);

  String client;
  String? server;
  String? serverLauncher;

  factory FabricMainClass.fromJson(Map<String, dynamic> json) => _$FabricMainClassFromJson(json);

  Map<String, dynamic> toJson() => _$FabricMainClassToJson(this);
}

@JsonSerializable()
class FabricVersion {
  FabricVersion(this.separator, this.build, this.maven, this.version, this.stable);
  
  String? separator;
  int? build;
  String maven;
  String version;
  bool? stable;
  
  factory FabricVersion.fromJson(Map<String, dynamic> json) => _$FabricVersionFromJson(json);

  Map<String, dynamic> toJson() => _$FabricVersionToJson(this);
}
