import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:test/data_source/model/news_tile_model.dart';
import 'package:test/data_source/model/section_model.dart';

class NewsRepository {
  String apiKey = '?api-key=e8b6d3f0-fb4a-4444-935f-9b747f998dfc';
  String url = 'https://content.guardianapis.com';

  String stringedQueryParameters = '';

  Map<String, dynamic> queryParameters = {
    'query-fields': 'body',
    'from-date': DateFormat("yyyy-MM-dd")
        .format(DateTime.now().subtract(const Duration(days: 1))),
    'page-size': 20
  };

  Future<ArticleResponse> getArticles({Map<String, dynamic>? search}) async {
    ArticleResponse? articleModel;
    if (search!.isNotEmpty) {
      stringedQueryParameters = '';
      for (var item in search.entries) {
        if (!queryParameters.containsKey(item.key)) {
          queryParameters.putIfAbsent(item.key, () => item.value);
        } else {
          queryParameters.update(item.key, (value) => item.value);
        }
      }
    } else {}

    for (var items in queryParameters.entries) {
      stringedQueryParameters =
          '$stringedQueryParameters&${items.key}=${items.value}';
    }

    http.Response response =
        await http.get(Uri.parse('$url/search$apiKey$stringedQueryParameters'));
    if (response.statusCode == 200) {
      log('Response status: ${response.statusCode}:${response.body}');
      var toMapResponse = json.decode(response.body)['response'];

      articleModel = ArticleResponse.fromJson(toMapResponse);
    }
    return articleModel!;
  }

  Future<SectionsResponse> getSections() async {
    SectionsResponse? sectionModel;
    http.Response response = await http
        .get(Uri.parse('$url/sections$apiKey$stringedQueryParameters'));
    if (response.statusCode == 200) {
      log('Response status: ${response.statusCode}:${response.body}');
      var toMapResponse = json.decode(response.body)['response'];

      sectionModel = SectionsResponse.fromJson(toMapResponse);
    }
    return sectionModel!;
  }
}
