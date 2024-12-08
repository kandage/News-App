import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/state_manager.dart';
import '../helpers/voice_search.dart';
import '../screens/news_detail_screen.dart';
import '../widgets/news_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<void> _fetchArticlesFuture;
  final VoiceSearch _voiceSearch = VoiceSearch();

  @override
  void initState() {
    super.initState();
    _fetchArticlesFuture = Provider.of<NewsProvider>(context, listen: false).fetchArticles();
  }

  void _searchArticles() {
    setState(() {
      _fetchArticlesFuture = Provider.of<NewsProvider>(context, listen: false).searchArticles(_searchController.text);
    });
  }

  void _startVoiceSearch() {
    _voiceSearch.listen((recognizedWords) {
      setState(() {
        _searchController.text = recognizedWords;
        _searchArticles();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final articles = Provider.of<NewsProvider>(context).articles;

    return Scaffold(
      appBar: AppBar(
        title: const Text("News App"),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Enter search term",
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _searchArticles,
                    ),
                    IconButton(
                      icon: const Icon(Icons.mic),
                      onPressed: _startVoiceSearch,
                    ),
                  ],
                ),
              ),
              onSubmitted: (value) => _searchArticles(),
            ),
          ),

          // Articles List
          Expanded(
            child: FutureBuilder(
              future: _fetchArticlesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error fetching news"));
                } else if (articles.isEmpty) {
                  return const Center(child: Text("No news articles found"));
                } else {
                  return ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NewsDetailScreen(article: article),
                            ),
                          );
                        },
                        child: NewsCard(article: article),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
