import 'package:get/get.dart';
import '../../../data/providers/article_provider.dart';
import '../controllers/article_controller.dart';

class ArticleBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure ArticleProvider is initialized
    if (!Get.isRegistered<ArticleProvider>()) {
      Get.lazyPut<ArticleProvider>(() => ArticleProvider());
    }

    // Initialize ArticleController
    Get.lazyPut<ArticleController>(() => ArticleController());
  }
}
