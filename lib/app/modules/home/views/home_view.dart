import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
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
                            color: Colors.black,
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

                // Services Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return GestureDetector(
                      onTap: () => controller.selectCategory(index),
                      child: Obx(() {
                        final isSelected =
                            controller.selectedCategory.value == index;
                        return Container(
                          // decoration: BoxDecoration(
                          //   color: Colors.white,
                          //   borderRadius: BorderRadius.circular(16),
                          //   border: Border.all(
                          //     color: Colors.grey.shade300,
                          //     width: isSelected ? 2 : 1,
                          //   ),
                          //   boxShadow: [
                          //     BoxShadow(
                          //       color: Colors.black.withOpacity(0.05),
                          //       blurRadius: 8,
                          //       offset: const Offset(0, 2),
                          //     ),
                          //   ],
                          // ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 84,
                                height: 84,
                                // decoration: BoxDecoration(
                                //   color: Colors.grey[100],
                                //   borderRadius: BorderRadius.circular(12),
                                // ),
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  category['image']!,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                category['name']!,
                                style: TextStyle(
                                  fontSize: 12,

                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
