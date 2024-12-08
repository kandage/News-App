class NewsArticle {
  final String title;
  final String? description;
  final String? url;
  final String? imageUrl;
  final DateTime? publishedAt; // Make nullable
  final DateTime? publishedTime; // Make nullable
  final int? viewsCount; // Make nullable

  NewsArticle({
    required this.title,
    this.description,
    this.url,
    this.imageUrl,
    this.publishedAt,
    this.publishedTime,
    this.viewsCount,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] as String,
      description: json['description'] as String?,
      url: json['url'] as String?,
      imageUrl: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] != null ? DateTime.parse(json['publishedAt']) : null,
      publishedTime: json['publishedTime'] != null ? DateTime.parse(json['publishedTime']) : null,
      viewsCount: json['viewsCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': imageUrl,
      'publishedAt': publishedAt?.toIso8601String(),
      'publishedTime': publishedTime?.toIso8601String(),
      'viewsCount': viewsCount,
    };
  }
}
