import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:http/http.dart' as http;
import 'package:pencil/constants.dart';
import 'package:pencil/data/pencil/news/mojang_news.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  late Future<MinecraftNews> _newsFuture;
  final ScrollController _controller = ScrollController();

  Future<MinecraftNews> getNews() async {
    http.Response response =
        await http.get(Uri.parse('https://launchercontent.mojang.com/news.json'), headers: {'User-Agent': kUserAgent});
    if (response.statusCode != 200) {
      throw Exception(FlutterI18n.translate(context, 'home.news.errorDescription',
          translationParams: {'code': response.statusCode.toString()}));
    }
    return MinecraftNews.fromJson(json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
  }

  @override
  void initState() {
    super.initState();
    _newsFuture = getNews();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SizedBox(
        height: 275,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FutureBuilder<MinecraftNews>(
              future: _newsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                      child: Scrollbar(
                          controller: _controller,
                          child: ListView(controller: _controller, scrollDirection: Axis.horizontal, children: [
                            for (MojangNews news in snapshot.data!.entries)
                              Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 350,
                                  child: Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      color: theme.colorScheme.inversePrimary.withAlpha(50),
                                      child: InkWell(
                                          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          onTap: () async {
                                            await launchUrl(Uri.parse(news.readMoreLink));
                                          },
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    width: 350,
                                                    height: 150,
                                                    child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(16),
                                                        child: FadeInImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              'https://launchercontent.mojang.com${news.newsPageImage.url}'),
                                                          height: 150,
                                                          placeholder: MemoryImage(kTransparentImage),
                                                        ))),
                                                Padding(
                                                    padding: const EdgeInsets.all(12),
                                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                      Container(
                                                          margin: const EdgeInsets.only(bottom: 5),
                                                          child: Text(news.title,
                                                              style: theme.textTheme.titleMedium!
                                                                  .copyWith(fontSize: 18, height: 1.1))),
                                                      Text(news.text, style: theme.textTheme.bodySmall)
                                                    ]))
                                              ]))))
                          ])));
                } else if (snapshot.hasError) {
                  return Expanded(
                      child: Center(
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Icon(Icons.error, color: theme.colorScheme.error, size: 48)),
                    I18nText('home.news.error')
                  ])));
                } else {
                  return const Expanded(child: Center(child: CircularProgressIndicator()));
                }
              })
        ]));
  }
}
