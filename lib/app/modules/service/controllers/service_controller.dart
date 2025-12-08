import 'package:get/get.dart';
import 'package:resikan_app/app/data/models/service_model.dart';
import 'package:resikan_app/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServiceController extends GetxController {
  final supabase = Supabase.instance.client;

  // Observable states
  final services = <ServiceModel>[].obs;
  final isLoading = false.obs;
  final selectedCategory = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadServices();
  }

  // Load all active services
  Future<void> loadServices() async {
    try {
      isLoading.value = true;

      // Load all active services
      final response = await supabase
          .from('services')
          .select()
          .eq('active', true)
          .order('created_at', ascending: false);

      services.value = (response as List)
          .map((json) => ServiceModel.fromJson(json))
          .toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat layanan: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Filter by category
  void filterByCategory(String? category) {
    selectedCategory.value = category;
    loadServices();
  }

  // Get service by ID
  Future<ServiceModel?> getServiceById(String id) async {
    try {
      final response = await supabase
          .from('services')
          .select()
          .eq('id', id)
          .single();

      return ServiceModel.fromJson(response);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat detail layanan: $e');
      return null;
    }
  }

  // Navigate to service detail
  void goToServiceDetail(ServiceModel service) {
    Get.toNamed(Routes.SERVICE_DETAIL, arguments: service);
  }
}
