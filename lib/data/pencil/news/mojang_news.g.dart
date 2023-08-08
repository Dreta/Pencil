// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mojang_news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MinecraftNews _$MinecraftNewsFromJson(Map<String, dynamic> json) =>
    MinecraftNews(
      json['version'] as int,
      (json['entries'] as List<dynamic>)
          .map((e) => MojangNews.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MinecraftNewsToJson(MinecraftNews instance) =>
    <String, dynamic>{
      'version': instance.version,
      'entries': instance.entries,
    };

MojangNews _$MojangNewsFromJson(Map<String, dynamic> json) => MojangNews(
      json['title'] as String,
      json['tag'] as String?,
      json['category'] as String?,
      json['date'] as String,
      json['text'] as String,
      MojangNewsImage.fromJson(json['playPageImage'] as Map<String, dynamic>),
      MojangNewsImage.fromJson(json['newsPageImage'] as Map<String, dynamic>),
      json['readMoreLink'] as String,
      json['cardBorder'] as bool?,
      (json['newsType'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['id'] as String,
    );

Map<String, dynamic> _$MojangNewsToJson(MojangNews instance) =>
    <String, dynamic>{
      'title': instance.title,
      'tag': instance.tag,
      'category': instance.category,
      'date': instance.date,
      'text': instance.text,
      'playPageImage': instance.playPageImage,
      'newsPageImage': instance.newsPageImage,
      'readMoreLink': instance.readMoreLink,
      'cardBorder': instance.cardBorder,
      'newsType': instance.newsType,
      'id': instance.id,
    };

MojangNewsImage _$MojangNewsImageFromJson(Map<String, dynamic> json) =>
    MojangNewsImage(
      json['title'] as String?,
      json['url'] as String,
      json['dimensions'] == null
          ? null
          : NewsImageDimensions.fromJson(
              json['dimensions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MojangNewsImageToJson(MojangNewsImage instance) =>
    <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
      'dimensions': instance.dimensions,
    };

NewsImageDimensions _$NewsImageDimensionsFromJson(Map<String, dynamic> json) =>
    NewsImageDimensions(
      json['width'] as int,
      json['height'] as int,
    );

Map<String, dynamic> _$NewsImageDimensionsToJson(
        NewsImageDimensions instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
    };
