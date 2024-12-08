import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_article.dart';

class ApiService {
  static const _apiKey = '04d2016527204bbc917072b349c240bf';
  static const _baseUrl = 'https://newsapi.org/v2/';

  Future<List<NewsArticle>> fetchArticles() async {
    final response = await http
        .get(Uri.parse('${_baseUrl}top-headlines?country=us&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articlesJson = data['articles'];
      return articlesJson.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<List<NewsArticle>> fetchArticlesByCategory(String category) async {
    final response = await http.get(Uri.parse(
        '${_baseUrl}top-headlines?country=us&category=$category&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articlesJson = data['articles'];
      return articlesJson.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<List<NewsArticle>> searchArticles(String query) async {
    final response = await http
        .get(Uri.parse('${_baseUrl}everything?q=$query&apiKey=$_apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articlesJson = data['articles'];
      return articlesJson.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search news');
    }
  }
}
