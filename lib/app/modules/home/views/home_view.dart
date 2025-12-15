import 'package:resikan_app/app/config/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resikan_app/app/widgets/service_icon_widget.dart';
import 'package:resikan_app/app/widgets/article_card_widget.dart';
import 'package:resikan_app/app/data/providers/article_provider.dart';
import 'package:resikan_app/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ArticleProvider if not already
    if (!Get.isRegistered<ArticleProvider>()) {
      Get.put(ArticleProvider());
    }
    final articleProvider = Get.find<ArticleProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Anas',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ThemeConfig.primary,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Banner Promo
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'images/banner-promo.png',
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(height: 32),

                // Services Title
                const Text(
                  'Services',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                // Services Grid - from database
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (controller.services.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.cleaning_services_outlined,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Tidak ada layanan',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: controller.services.length,
                    itemBuilder: (context, index) {
                      final service = controller.services[index];
                      return GestureDetector(
                        onTap: () => controller.goToServiceDetail(service),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ServiceIconWidget(
                              service: service,
                              size: 64,
                              color: ThemeConfig.primary,
                              backgroundColor: ThemeConfig.primary.withAlpha(
                                25,
                              ),
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              service.name,
                              style: const TextStyle(
                                fontSize: 12,
                                color: ThemeConfig.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
                const SizedBox(height: 32),

                // Articles Section
                Obx(() {
                  if (articleProvider.recentArticles.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return ArticlesSection(
                    articles: articleProvider.recentArticles,
                    onSeeAll: () {
                      Get.toNamed(Routes.ARTICLE_LIST);
                    },
                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
