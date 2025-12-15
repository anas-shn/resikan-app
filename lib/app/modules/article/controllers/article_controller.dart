import 'package:get/get.dart';
import '../../../data/models/article_model.dart';
import '../../../data/providers/article_provider.dart';

class ArticleController extends GetxController {
  final ArticleProvider _articleProvider = Get.find<ArticleProvider>();

  final RxList<ArticleModel> articles = <ArticleModel>[].obs;
  final RxList<ArticleModel> recentArticles = <ArticleModel>[].obs;
  final Rx<ArticleModel?> selectedArticle = Rx<ArticleModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadArticles();
  }

  /// Load all articles
  Future<void> loadArticles() async {
    try {
      isLoading.value = true;
      await _articleProvider.loadArticles();
      articles.value = _articleProvider.articles;
      recentArticles.value = _articleProvider.recentArticles;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load articles: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Load article by ID
  Future<void> loadArticleById(int id) async {
    try {
      isLoading.value = true;
      final article = await _articleProvider.getArticleById(id);
      if (article != null) {
        selectedArticle.value = article;
      } else {
        Get.snackbar(
          'Error',
          'Article not found',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load article: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Search articles
  Future<void> searchArticles(String query) async {
    try {
      searchQuery.value = query;
      if (query.isEmpty) {
        articles.value = _articleProvider.articles;
      } else {
        final results = await _articleProvider.searchArticles(query);
        articles.value = results;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to search articles: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Refresh articles
  Future<void> refresh() async {
    await loadArticles();
  }

  /// Get recent articles for home page
  List<ArticleModel> get homeArticles {
    return recentArticles.take(5).toList();
  }

  /// Check if has articles
  bool get hasArticles => articles.isNotEmpty;

  /// Get articles count
  int get articlesCount => articles.length;
}
