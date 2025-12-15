import 'package:intl/intl.dart';

class ArticleModel {
  final int id;
  final String title;
  final String? excerpt;
  final String content;
  final String imageUrl;
  final String? author;
  final DateTime publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ArticleModel({
    required this.id,
    required this.title,
    this.excerpt,
    required this.content,
    required this.imageUrl,
    this.author,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert from SQLite JSON/Map
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] as int,
      title: json['title'] as String,
      excerpt: json['excerpt'] as String?,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String,
      author: json['author'] as String?,
      publishedAt: DateTime.parse(json['published_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'excerpt': excerpt,
      'content': content,
      'image_url': imageUrl,
      'author': author,
      'published_at': publishedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Formatted date for display (e.g., "1 Dec, 22")
  String get formattedDate {
    return DateFormat('d MMM, yy').format(publishedAt);
  }

  // Formatted date for detail view (e.g., "1 December 2022")
  String get formattedDateLong {
    return DateFormat('d MMMM yyyy').format(publishedAt);
  }

  // Get reading time estimate (based on 200 words per minute)
  String get readingTime {
    final wordCount = content.split(RegExp(r'\s+')).length;
    final minutes = (wordCount / 200).ceil();
    return '$minutes min read';
  }

  // Copy with method for immutability
  ArticleModel copyWith({
    int? id,
    String? title,
    String? excerpt,
    String? content,
    String? imageUrl,
    String? author,
    DateTime? publishedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author ?? this.author,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ArticleModel(id: $id, title: $title, publishedAt: $publishedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ArticleModel &&
        other.id == id &&
        other.title == title &&
        other.content == content;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ content.hashCode;
  }
}
