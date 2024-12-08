import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_article.dart';
import 'api_service.dart';

class NewsProvider with ChangeNotifier {
  List<NewsArticle> _articles = [];
  List<NewsArticle> _favorites = [];
  bool _isDarkTheme = false;

  List<NewsArticle> get articles => _articles;
  List<NewsArticle> get favorites => _favorites;
  bool get isDarkTheme => _isDarkTheme;

  // Check if the article is favorited
  bool isFavorited(NewsArticle article) {
    return _favorites.contains(article);
  }

  Future<void> fetchArticles() async {
    _articles = await ApiService().fetchArticles();
    notifyListeners();
  }

  Future<void> fetchArticlesByCategory(String category) async {
    _articles = await ApiService().fetchArticlesByCategory(category);
    notifyListeners();
  }

  Future<void> searchArticles(String query) async {
    _articles = await ApiService().searchArticles(query);
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favArticles = prefs.getStringList('favorites');
    if (favArticles != null) {
      _favorites = favArticles.map((json) => NewsArticle.fromJson(jsonDecode(json))).toList();
    }
    notifyListeners();
  }

  Future<void> toggleFavorite(NewsArticle article) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_favorites.contains(article)) {
      _favorites.remove(article);
    } else {
      _favorites.add(article);
    }
    List<String> favArticles = _favorites.map((article) => jsonEncode(article.toJson())).toList();
    prefs.setStringList('favorites', favArticles);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkTheme = !_isDarkTheme;
    prefs.setBool('isDarkTheme', _isDarkTheme);
    notifyListeners();
  }

  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    notifyListeners();
  }
}

