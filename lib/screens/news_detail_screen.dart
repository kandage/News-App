import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_article.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Article Image
              article.imageUrl != null
                  ? Image.network(article.imageUrl!)
                  : Image.network('https://via.placeholder.com/150'),
              const SizedBox(height: 10),

              // Article Title
              Text(
                article.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),

              // Article Description
              Text(article.description ?? 'No description available'),
              const SizedBox(height: 20),

              // Read Full Article Button
              ElevatedButton(
                onPressed: () async {
                  final url = article.url;
                  if (url != null && await canLaunch(url)) {
                    await launch(url);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Cannot open the article")),
                    );
                  }
                },
                child: const Text("Read Full Article"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
