import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/state_manager.dart';
import '../helpers/voice_search.dart';
import '../widgets/news_card.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  const CategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<void> _fetchArticlesByCategoryFuture;
  final VoiceSearch _voiceSearch = VoiceSearch();

  @override
  void initState() {
    super.initState();
    _fetchArticlesByCategoryFuture = Provider.of<NewsProvider>(context, listen: false).fetchArticlesByCategory(widget.category);
  }

  void _searchArticles() {
    setState(() {
      _fetchArticlesByCategoryFuture = Provider.of<NewsProvider>(context, listen: false).searchArticles(_searchController.text);
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
        title: Text("${widget.category} News"),
      ),
      body: Column(
        children: [
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
          Expanded(
            child: FutureBuilder(
              future: _fetchArticlesByCategoryFuture,
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
                      return NewsCard(article: articles[index]);
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
