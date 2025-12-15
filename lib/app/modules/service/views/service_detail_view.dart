import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resikan_app/app/config/theme_config.dart';
import 'package:resikan_app/app/data/models/service_model.dart';
import 'package:resikan_app/app/routes/app_pages.dart';
import '../controllers/service_controller.dart';

class ServiceDetailView extends GetView<ServiceController> {
  const ServiceDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ServiceModel service = Get.arguments as ServiceModel;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar with back button
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(color: Colors.blue),
                child: Stack(
                  children: [
                    // Image positioned at bottom right
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                        ),
                        child: Image.asset(
                          'images/people-clean.png',
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
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
                  // Service name
                  Text(
                    service.name,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),

                  // Price & Duration
                  Row(
                    children: [
                      Icon(Icons.payments, size: 20, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text(
                        service.formattedPrice,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ThemeConfig.primary,
                        ),
                      ),
                      SizedBox(width: 20),
                      Icon(Icons.schedule, size: 20, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text(
                        service.durationDisplay,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Description
                  Text(
                    'Deskripsi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    service.description ?? 'Tidak ada deskripsi',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24),

                  // Features (from metadata if available)
                  if (service.metadata?['features'] != null) ...[
                    Text(
                      'Yang Termasuk',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    ...((service.metadata!['features'] as List).map((feature) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 20,
                              color: Colors.green,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                feature.toString(),
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      );
                    })),
                    SizedBox(height: 24),
                  ],

                  SizedBox(height: 60), // Space for button
                ],
              ),
            ),
          ),
        ],
      ),

      // Floating Book Button
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.CREATE_BOOKING, arguments: service);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConfig.primary,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Pesan Layanan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
