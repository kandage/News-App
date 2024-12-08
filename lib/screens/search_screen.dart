import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/state_manager.dart';
import '../widgets/news_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<void> _searchArticlesFuture;

  @override
  void initState() {
    super.initState();
    _searchArticlesFuture = Provider.of<NewsProvider>(context, listen: false).fetchArticles();
  }

  void _searchArticles() {
    setState(() {
      _searchArticlesFuture = Provider.of<NewsProvider>(context, listen: false).searchArticles(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final articles = Provider.of<NewsProvider>(context).articles;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search News"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Enter search term",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchArticles,
                ),
              ),
              onSubmitted: (value) => _searchArticles(),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _searchArticlesFuture,
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
