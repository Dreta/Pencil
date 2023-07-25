import 'package:json_annotation/json_annotation.dart';

part 'mojang_news.g.dart';

@JsonSerializable()
class MinecraftNews {
  MinecraftNews(this.version, this.entries);

  final int version;
  final List<MojangNews> entries;

  factory MinecraftNews.fromJson(Map<String, dynamic> json) => _$MinecraftNewsFromJson(json);

  Map<String, dynamic> toJson() => _$MinecraftNewsToJson(this);
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class MojangNews {
  MojangNews(this.title, this.tag, this.category, this.date, this.text, this.playPageImage, this.newsPageImage, this.readMoreLink,
      this.cardBorder, this.newsType, this.id);

  final String title;
  String? tag;
  String? category;
  final String date;
  final String text;
  final MojangNewsImage playPageImage;
  final MojangNewsImage newsPageImage;
  final String readMoreLink;
  bool? cardBorder;
  List<String>? newsType;
  final String id;

  factory MojangNews.fromJson(Map<String, dynamic> json) => _$MojangNewsFromJson(json);

  Map<String, dynamic> toJson() => _$MojangNewsToJson(this);
}

@JsonSerializable()
class MojangNewsImage {
  MojangNewsImage(this.title, this.url, this.dimensions);

  String? title;
  final String url;
  NewsImageDimensions? dimensions;

  factory MojangNewsImage.fromJson(Map<String, dynamic> json) => _$MojangNewsImageFromJson(json);

  Map<String, dynamic> toJson() => _$MojangNewsImageToJson(this);
}

@JsonSerializable()
class NewsImageDimensions {
  NewsImageDimensions(this.width, this.height);

  final int width;
  final int height;

  factory NewsImageDimensions.fromJson(Map<String, dynamic> json) => _$NewsImageDimensionsFromJson(json);

  Map<String, dynamic> toJson() => _$NewsImageDimensionsToJson(this);
}
