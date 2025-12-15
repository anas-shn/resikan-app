import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/article_model.dart';
import 'supabase_provider.dart';

class ArticleProvider extends GetxController {
  static ArticleProvider get to => Get.find();

  final _supabase = SupabaseProvider.to;
  SupabaseClient get client => _supabase.client;

  // Observable lists
  final RxList<ArticleModel> articles = <ArticleModel>[].obs;
  final RxList<ArticleModel> recentArticles = <ArticleModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadArticles();
  }

  /// Load all articles
  Future<void> loadArticles() async {
    try {
      isLoading.value = true;

      final response = await client
          .from('articles')
          .select()
          .order('published_at', ascending: false);

      articles.value = (response as List)
          .map((json) => ArticleModel.fromJson(json))
          .toList();

      // Load recent articles (last 5)
      loadRecentArticles();
    } catch (e) {
      print('Error loading articles: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Load recent articles (for home page)
  Future<void> loadRecentArticles() async {
    try {
      final response = await client
          .from('articles')
          .select()
          .order('published_at', ascending: false)
          .limit(5);

      recentArticles.value = (response as List)
          .map((json) => ArticleModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error loading recent articles: $e');
    }
  }

  /// Get article by ID
  Future<ArticleModel?> getArticleById(int id) async {
    try {
      final response = await client
          .from('articles')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response != null) {
        return ArticleModel.fromJson(response);
      }
      return null;
    } catch (e) {
      print('Error getting article: $e');
      return null;
    }
  }

  /// Search articles by title or content
  Future<List<ArticleModel>> searchArticles(String query) async {
    try {
      if (query.isEmpty) {
        return articles;
      }

      final response = await client
          .from('articles')
          .select()
          .or('title.ilike.%$query%,content.ilike.%$query%')
          .order('published_at', ascending: false);

      return (response as List)
          .map((json) => ArticleModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error searching articles: $e');
      return [];
    }
  }

  /// Create new article (admin only)
  Future<ArticleModel?> createArticle(ArticleModel article) async {
    try {
      final response = await client
          .from('articles')
          .insert(article.toJson())
          .select()
          .single();

      final newArticle = ArticleModel.fromJson(response);
      articles.insert(0, newArticle);
      loadRecentArticles();

      return newArticle;
    } catch (e) {
      print('Error creating article: $e');
      return null;
    }
  }

  /// Update article (admin only)
  Future<bool> updateArticle(int id, ArticleModel article) async {
    try {
      await client.from('articles').update(article.toJson()).eq('id', id);

      final index = articles.indexWhere((a) => a.id == id);
      if (index != -1) {
        articles[index] = article;
      }

      loadRecentArticles();
      return true;
    } catch (e) {
      print('Error updating article: $e');
      return false;
    }
  }

  /// Delete article (admin only)
  Future<bool> deleteArticle(int id) async {
    try {
      await client.from('articles').delete().eq('id', id);

      articles.removeWhere((a) => a.id == id);
      loadRecentArticles();
      return true;
    } catch (e) {
      print('Error deleting article: $e');
      return false;
    }
  }

  /// Get articles by date range
  Future<List<ArticleModel>> getArticlesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final response = await client
          .from('articles')
          .select()
          .gte('published_at', start.toIso8601String())
          .lte('published_at', end.toIso8601String())
          .order('published_at', ascending: false);

      return (response as List)
          .map((json) => ArticleModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error getting articles by date range: $e');
      return [];
    }
  }

  /// Get articles by author
  Future<List<ArticleModel>> getArticlesByAuthor(String author) async {
    try {
      final response = await client
          .from('articles')
          .select()
          .eq('author', author)
          .order('published_at', ascending: false);

      return (response as List)
          .map((json) => ArticleModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error getting articles by author: $e');
      return [];
    }
  }

  /// Get articles count
  int get articlesCount => articles.length;

  /// Check if has articles
  bool get hasArticles => articles.isNotEmpty;

  /// Refresh articles
  Future<void> refresh() async {
    await loadArticles();
  }

  /// Clear all data
  void clear() {
    articles.clear();
    recentArticles.clear();
  }

  /// Subscribe to realtime changes (optional)
  void subscribeToArticles() {
    client
        .from('articles')
        .stream(primaryKey: ['id'])
        .order('published_at', ascending: false)
        .listen((List<Map<String, dynamic>> data) {
          articles.value = data
              .map((json) => ArticleModel.fromJson(json))
              .toList();
          loadRecentArticles();
        });
  }
}
