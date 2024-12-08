import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/news_article.dart';
import '../helpers/tts_helper.dart';
import '../helpers/state_manager.dart';

class NewsCard extends StatelessWidget {
  final NewsArticle article;
  final TTSHelper _ttsHelper = TTSHelper();

  NewsCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(article.imageUrl ?? 'https://via.placeholder.com/150'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              article.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(article.description ?? 'No description available'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () => _ttsHelper.speak(article.description ?? 'No description available'),
              ),
              Consumer<NewsProvider>( // Use Consumer to listen to provider changes
                builder: (context, newsProvider, _) {
                  bool isFavorited = newsProvider.isFavorited(article);

                  return IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: isFavorited ? Colors.green : Colors.grey, // Set color based on favorite status
                    ),
                    onPressed: () {
                      // Toggle favorite on icon press
                      newsProvider.toggleFavorite(article);
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
