import 'dart:convert';

import 'package:myscout/news/news_model.dart';
import 'package:http/http.dart' as http;
import 'package:myscout/utils/Config.dart';
class Api{
  static final String baseUrl = "http://api.linkpreview.net/?key=";
  static Future<News> fetchCompleteLinkData(
      String linkUrl) async {
    final response = await http.get(baseUrl +Config.linkPreviewAccessKey+"&q="+linkUrl);
    print(response);

    final responseJson = json.decode(response.body);
    print(responseJson);

    return News.fromJson(responseJson);
  }
}