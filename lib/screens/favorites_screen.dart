import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/state_manager.dart';
import '../widgets/news_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<NewsProvider>(context).favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return NewsCard(article: favorites[index]);
        },
      ),
    );
  }
}
