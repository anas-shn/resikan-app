import 'package:resikan_app/app/config/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resikan_app/app/modules/account/views/account_view.dart';
import 'package:resikan_app/app/modules/history/views/history_view.dart';
import 'package:resikan_app/app/modules/home/views/home_view.dart';
import 'package:resikan_app/app/modules/navigation/controllers/navigation_controller.dart';
import 'package:resikan_app/app/modules/service/views/service_view.dart';

class NavigationView extends GetView<NavigationController> {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeView(),
      const ServiceView(),
      const HistoryView(),
      const AccountView(),
    ];

    return Scaffold(
      body: Obx(
        () =>
            IndexedStack(index: controller.currentIndex.value, children: pages),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: ThemeConfig.primary.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem(
                    icon: Icons.home,
                    index: 0,
                    label: 'Home',
                    isActive: controller.currentIndex.value == 0,
                  ),
                  _buildNavItem(
                    icon: Icons.add_box,
                    index: 1,
                    label: 'Services',
                    isActive: controller.currentIndex.value == 1,
                  ),
                  _buildNavItem(
                    icon: Icons.history,
                    index: 2,
                    label: 'History',
                    isActive: controller.currentIndex.value == 2,
                  ),
                  _buildNavItem(
                    icon: Icons.person,
                    index: 3,
                    label: 'Account',
                    isActive: controller.currentIndex.value == 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required String label,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => controller.changePage(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? ThemeConfig.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.grey[600],
              size: 24,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
