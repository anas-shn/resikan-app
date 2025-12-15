import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/theme_config.dart';
import '../controllers/article_controller.dart';

class ArticleDetailView extends GetView<ArticleController> {
  const ArticleDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get article ID from route parameter
    final articleId = int.tryParse(Get.parameters['id'] ?? '0') ?? 0;

    // Load article when view is built
    if (articleId > 0) {
      controller.loadArticleById(articleId);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final article = controller.selectedArticle.value;
        if (article == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Article not found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeConfig.primary,
                  ),
                  child: Text('Go Back'),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            // App Bar with image
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: ThemeConfig.primary,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      article.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey[400],
                              size: 60,
                            ),
                          ),
                        );
                      },
                    ),
                    // Gradient overlay
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Article metadata
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 8),
                        Text(
                          article.formattedDateLong,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 16),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 8),
                        Text(
                          article.readingTime,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Title
                    Text(
                      article.title,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 12),

                    // Author
                    if (article.author != null) ...[
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: ThemeConfig.primary.withOpacity(
                              0.2,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 18,
                              color: ThemeConfig.primary,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'By ${article.author}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                    ],

                    // Excerpt (if available)
                    if (article.excerpt != null) ...[
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ThemeConfig.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ThemeConfig.primary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          article.excerpt!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            height: 1.6,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                    ],

                    // Divider
                    Divider(color: Colors.grey[300], thickness: 1),
                    SizedBox(height: 20),

                    // Content
                    Text(
                      article.content,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        height: 1.8,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 40),

                    // Share button
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.share, color: ThemeConfig.primary),
                          SizedBox(width: 12),
                          Text(
                            'Share this article',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: ThemeConfig.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
